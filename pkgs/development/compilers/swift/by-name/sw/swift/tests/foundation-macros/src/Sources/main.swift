import Foundation

let wordPred = #Predicate<String> { s in s == "foundation" || s == "macros" }

let words = [
    "foo",
    "foundation",
    "macros",
    "swift",
    "world",
]
let filtered = try! words.filter(wordPred)

print("Hello, \(filtered.joined(separator: " "))")
