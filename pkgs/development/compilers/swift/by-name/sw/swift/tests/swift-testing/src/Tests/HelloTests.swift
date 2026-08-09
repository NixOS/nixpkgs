import Testing

@testable import test_swift_testing

@Suite struct HelloStructTests {
    @Test func itSaysHello() {
        let expected = "Hello, Nixpkgs!"

        let s = HelloStruct(message: "Nixpkgs!")
        let result = s.sayHello()

        #expect(result == expected)
    }
}
