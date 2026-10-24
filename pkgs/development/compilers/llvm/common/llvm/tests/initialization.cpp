// Exercise actual LLVM headers and, when present, SFrameParser.cpp. No JIT.
#include "llvm/ADT/iterator.h"
#include "llvm/ADT/STLExtras.h"
#if HAVE_SFRAME
#include "llvm/Object/SFrameParser.h"
#endif
#if HAVE_COUNT_COPY_AND_MOVE
#include "CountCopyAndMove.h"
#endif
#include <cassert>
#include <cstring>
#include <functional>
#include <type_traits>
#include <utility>
#include <vector>

using namespace llvm;

#if HAVE_COUNT_COPY_AND_MOVE
#if HAVE_CONSTRUCTION_COUNTERS
int CountCopyAndMove::DefaultConstructions = 0;
int CountCopyAndMove::ValueConstructions = 0;
#endif
int CountCopyAndMove::CopyConstructions = 0;
int CountCopyAndMove::CopyAssignments = 0;
int CountCopyAndMove::MoveConstructions = 0;
int CountCopyAndMove::MoveAssignments = 0;
int CountCopyAndMove::Destructions = 0;
#endif

#if HAVE_SFRAME
template <endianness E> static void checkSFrame(unsigned Count) {
  sframe::Header<E> Header{};
  Header.Preamble.Magic = sframe::Magic;
  Header.Preamble.Version = sframe::Version::V2;
  Header.NumFDEs = 1;
  Header.NumFREs = Count;
  Header.FRELen = Count * 3;
  sframe::FuncDescEntry<E> FDE{};
  FDE.NumFREs = Count;
  FDE.Info.setFREType(sframe::FREType::Addr1);
  std::vector<uint8_t> Data(sizeof(Header) + sizeof(FDE) + Count * 3);
  std::memcpy(Data.data(), &Header, sizeof(Header));
  std::memcpy(Data.data() + sizeof(Header), &FDE, sizeof(FDE));
  for (unsigned I = 0; I != Count; ++I) {
    auto *Row = Data.data() + sizeof(Header) + sizeof(FDE) + I * 3;
    Row[0] = I * 7;
    Row[1] = 3; // one byte CFA offset, SP base register
    Row[2] = 8 * (I + 1);
  }
  auto Parser = cantFail(object::SFrameParser<E>::create(Data, 0));
  auto FDEs = cantFail(Parser.fdes());
  Error Err = Error::success();
  auto Rows = Parser.fres(FDEs[0], Err);
  auto Copy = Rows.begin();
  auto Moved = std::move(Copy);
  unsigned Seen = 0;
  for (; Moved != Rows.end(); ++Moved, ++Seen) {
    assert((*Moved).StartAddress == Seen * 7);
    assert(Parser.getCFAOffset(*Moved) == 8 * (Seen + 1));
  }
  assert(Seen == Count);
  cantFail(std::move(Err));
}

#endif

int main() {
  int Values[] = {11, 29};
  static_assert(std::is_trivially_copy_constructible_v<pointer_iterator<int *>>);
  static_assert(std::is_trivially_move_constructible_v<pointer_iterator<int *>>);
  pointer_iterator<int *> Original(Values);
  auto Copy = Original; // copy and move before populating the pointer cache
  auto Moved = std::move(Copy);
  assert(*Moved == &Values[0]);
  ++Moved;
  assert(*Moved == &Values[1]);
  assert(*Original == &Values[0]);

  // A std::function predicate makes the wrapped iterator nontrivially copied.
  // This exercises memberwise copying of Ptr before dereference initializes it.
  std::function<bool(int)> Keep = [](int Value) { return Value != 29; };
  int FilteredValues[] = {11, 29, 47};
  auto Range = make_filter_range(FilteredValues, Keep);
  using Filtered = pointer_iterator<decltype(Range.begin())>;
  static_assert(!std::is_trivially_copy_constructible_v<Filtered>);
  static_assert(!std::is_trivially_move_constructible_v<Filtered>);
  Filtered FilteredOriginal(Range.begin());
  auto FilteredCopy = FilteredOriginal;
  auto FilteredMoved = std::move(FilteredCopy);
  assert(*FilteredMoved == &FilteredValues[0]);
  ++FilteredMoved;
  assert(*FilteredMoved == &FilteredValues[2]);
  assert(*FilteredOriginal == &FilteredValues[0]);

#if HAVE_COUNT_COPY_AND_MOVE
  CountCopyAndMove Default;
  assert(Default.val == 0);
  CountCopyAndMove Copied(Default), MovedValue(std::move(Copied));
  assert(MovedValue.val == 0);
  CountCopyAndMove Explicit(42);
  MovedValue = std::move(Explicit);
  assert(MovedValue.val == 42);

#endif
#if HAVE_SFRAME
  for (unsigned Count : {0, 1, 2}) {
    checkSFrame<endianness::little>(Count);
    checkSFrame<endianness::big>(Count);
  }
#endif
}
