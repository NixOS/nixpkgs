// Array.span can’t be backdeployed, so we have to work with buffer pointers for the test.
// See: https://forums.swift.org/t/using-span-on-pre-26-apple-os-versions/80513/4
let arr = [1, 2, 3, 4]

// Avoid `error: lifetime-dependent value escapes its scope` by extending the lifetime of the span.
arr.withUnsafeBufferPointer { ptr in
    let span = ptr.span
    for idx in span.indices {
        print("x: \(span[idx]);", terminator: "")
    }
}
