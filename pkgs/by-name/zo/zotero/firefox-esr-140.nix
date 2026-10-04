{
  lib,
  fetchurl,
  buildMozillaMach,
}:

buildMozillaMach rec {
  pname = "firefox";
  version = "140.17.0esr";
  applicationName = "Firefox ESR";
  src = fetchurl {
    url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
    sha512 = "c569f4f1ecbadec4c24ab60af6c8ff03f6c1292e7b2446edca7cc6f5575bd8d98e3ee9efb9877eba98bdb15354a4c4260515f8c6fd9aa9d198b26722f60ae5f4";
  };
  extraPatches = [
    # glibc >= 2.41 provides a native C11 <threads.h>, which clashes with the
    # emulation vendored in glslopt, and no longer lets the sandbox redefine
    # SYS_SECCOMP as a macro. Both are fixed upstream in Firefox >= 141.
    # https://bugzilla.mozilla.org/show_bug.cgi?id=2030493
    ./firefox-140-glibc-2.41-compat.patch
  ];
  extraPostPatch =
    # ./140-glibc-2.41-compat.patch touches a vendored crate, so its checksum
    # needs to be refreshed. The manifest is a single line of JSON, which is
    # impractical to patch.
    ''
      substituteInPlace third_party/rust/glslopt/.cargo-checksum.json \
        --replace-fail \
          f8ad2b69fa472e332b50572c1b2dcc1c8a0fa783a1199aad245398d3df421b4b \
          "$(sha256sum third_party/rust/glslopt/glsl-optimizer/include/c11/threads_posix.h | cut -d' ' -f1)"
    '';

  meta = {
    changelog = "https://www.firefox.com/en-US/firefox/${lib.removeSuffix "esr" version}/releasenotes/";
    description = "Web browser built from Firefox source tree";
    homepage = "http://www.mozilla.com/en-US/firefox/";
    maintainers = with lib.maintainers; [ mynacol ];
    platforms = lib.platforms.unix;
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
    mainProgram = "firefox";
    identifiers = {
      cpeParts = {
        product = "firefox";
        sw_edition = "esr";
        update = "*";
        vendor = "mozilla";
        version = lib.removeSuffix "esr" version;
      };
      purlParts = {
        type = "generic";
        spec = "firefox@${lib.removeSuffix "esr" version}";
      };
    };
  };
}
