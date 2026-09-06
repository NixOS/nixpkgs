import _Differentiation

@differentiable(reverse)
func f(x: Double) -> Double {
    return x * x
}

let m = gradient(at: Double(CommandLine.arguments[1])!, of: f)

print(m)
