Julia
=====

[Julia][julia], as a full-fledged programming language with an extensive
standard library that covers numerical computing, can be somewhat challenging to
package. This file aims to provide pointers which could not easily be included
as comments in the expressions themselves.

[julia]: https://julialang.org

For Nixpkgs, the manual is as always your primary reference, and for the Julia
side of things, you probably want to familiarise yourself with the [README
][readme], [build instructions][build], and [release process][release_process].
Remember that these can change between Julia releases, especially if the LTS and
release branches have deviated greatly. A lot of the build process is
underdocumented and thus there is no substitute for digging into the code that
controls the build process. You are very likely to need to use the test suite to
locate and address issues and in the end passing it, while only disabling a
minimal set of broken or incompatible tests you think you have a good reason to
disable, is your best bet at arriving at a solid derivation.

[readme]: https://github.com/JuliaLang/julia/blob/master/README.md
[build]: https://github.com/JuliaLang/julia/tree/master/doc/src/devdocs/build
[release_process]: https://julialang.org/blog/2019/08/release-process
