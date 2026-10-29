#include <iostream>

#include "Check-SwiftStruct.h"

int main() {
    auto swiftStruct = Check::SwiftStruct::init("Hello, C++!");
    std::cout << swiftStruct.getHello() << std::endl;
}
