// Both Swift Differentiation and Foundation are used to try to construct a test that can fail on both Darwin
// and Linux when the required libraries are not available.

import Foundation  // Linked separately from the stdlib on Linux.
import _Differentiation  // Linked from the Swift stdlib even on Darwin.

@differentiable(reverse)
func f(x: Double) -> Double {
    return x * x
}

let m = gradient(at: Double(CommandLine.arguments[1])!, of: f)

let data = Data("Hello, \(m)".utf8)
let str = String(decoding: data, as: UTF8.self)

print(str)
