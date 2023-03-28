{ overrideCC
, wrapCCWith
, stdenv
, compatibleStdenv
}:

overrideCC stdenv (wrapCCWith rec {
  cc = compatibleStdenv.cc.cc;
  libcxx = stdenv.cc.cc.lib;
})
