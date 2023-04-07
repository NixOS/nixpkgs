{ nixpkgsStdenv
, nvccCompatibleStdenv
, overrideCC
, wrapCCWith
}:

overrideCC nixpkgsStdenv (wrapCCWith {
  cc = nvccCompatibleStdenv.cc.cc;

  # This option is for clang's libcxx, but we (ab)use it for gcc's libstdc++.
  # Note that libstdc++ maintains forward-compatibility: if we load a newer
  # libstdc++ into the process, we can still use libraries built against an
  # older libstdc++. This, in practice, means that we should use libstdc++ from
  # the same stdenv that the rest of nixpkgs uses.
  # We currently do not try to support anything other than gcc and linux.
  libcxx = nixpkgsStdenv.cc.cc.lib;
})
