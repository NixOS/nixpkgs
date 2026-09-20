// Exercise actual LLVM headers and SFrameParser.cpp. No JIT code generation.
#include "llvm/ADT/iterator.h"
#include "llvm/Object/SFrameParser.h"
#include "CountCopyAndMove.h"
#include <cassert>
#include <cstring>
#include <utility>
#include <vector>

using namespace llvm;

int CountCopyAndMove::DefaultConstructions = 0;
int CountCopyAndMove::ValueConstructions = 0;
int CountCopyAndMove::CopyConstructions = 0;
int CountCopyAndMove::CopyAssignments = 0;
int CountCopyAndMove::MoveConstructions = 0;
int CountCopyAndMove::MoveAssignments = 0;
int CountCopyAndMove::Destructions = 0;

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

int main() {
  int Values[] = {11, 29};
  pointer_iterator<int *> Original(Values);
  auto Copy = Original; // copy and move before populating the pointer cache
  auto Moved = std::move(Copy);
  assert(*Moved == &Values[0]);
  ++Moved;
  assert(*Moved == &Values[1]);
  assert(*Original == &Values[0]);

  CountCopyAndMove Default;
  assert(Default.val == 0);
  CountCopyAndMove Copied(Default), MovedValue(std::move(Copied));
  assert(MovedValue.val == 0);
  CountCopyAndMove Explicit(42);
  MovedValue = std::move(Explicit);
  assert(MovedValue.val == 42);

  for (unsigned Count : {0, 1, 2}) {
    checkSFrame<endianness::little>(Count);
    checkSFrame<endianness::big>(Count);
  }
}
