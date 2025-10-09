{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  expat,
  pkg-config,
  systemdLibs,
}:
let
  generic =
    {
      version,
      rev ? "v${version}",
      hash,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "sdbus-cpp";
      inherit version;

      src = fetchFromGitHub {
        owner = "kistler-group";
        repo = "sdbus-cpp";
        inherit rev hash;
      };

      nativeBuildInputs = [
        cmake
        pkg-config
      ];

      buildInputs = [
        expat
        systemdLibs
      ];

      cmakeFlags = [
        (lib.cmakeBool (
          if lib.versionOlder finalAttrs.version "2.0.0" then "BUILD_CODE_GEN" else "SDBUSCPP_BUILD_CODEGEN"
        ) true)
      ];

      meta = {
        homepage = "https://github.com/Kistler-Group/sdbus-cpp";
        changelog = "https://github.com/Kistler-Group/sdbus-cpp/blob/v${version}/ChangeLog";
        description = "High-level C++ D-Bus library designed to provide easy-to-use yet powerful API";
        longDescription = ''
          sdbus-c++ is a high-level C++ D-Bus library for Linux designed to provide
          expressive, easy-to-use API in modern C++.
          It adds another layer of abstraction on top of sd-bus, a nice, fresh C
          D-Bus implementation by systemd.
          It's been written primarily as a replacement of dbus-c++, which currently
          suffers from a number of (unresolved) bugs, concurrency issues and
          inherent design complexities and limitations.
        '';
        license = lib.licenses.lgpl2Only;
        maintainers = with lib.maintainers; [ etwas ];
        platforms = lib.platforms.linux;
        mainProgram = "sdbus-c++-xml2cpp";
      };
    });
in
{
  sdbus-cpp = generic {
    version = "1.5.0";
    hash = "sha256-oO8QNffwNI245AEPdutOGqxj4qyusZYK3bZWLh2Lcag=";
  };

  sdbus-cpp_2 = generic {
    version = "2.1.0";
    hash = "sha256-JnjabBr7oELLsUV9a+dAAaRyUzaMIriu90vkaVJg2eY=";
  };
}
