{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, fetchFromGitHub
, substituteAll
, symlinkJoin
, cmake
, doxygen
, ruby
, validatePkgConfig
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iniparser";
  version = "4.2.3";

  src = fetchFromGitLab {
    owner = "iniparser";
    repo = "iniparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rCp9whYPYmVd7saVFILmpdn041u6fYGqe1/Oqc7RaeA=";
  };

  patches = [
    (fetchpatch {
      name = "fix-paths-pkgconfig-file.patch";
      url = "https://gitlab.com/iniparser/iniparser/-/commit/6a76cd5e97b32014b22d87039bf6f4ee425c79a2.patch";
      hash = "sha256-KlTxeOzwBZiLNmuwbbem5c/xspxsflyYfeUaQnGyarI=";
    })
  ] ++ lib.optionals finalAttrs.doCheck [
    (substituteAll {
      # Do not let cmake's fetchContent download unity
      src = ./remove-fetchcontent-usage.patch;
      unitySrc = symlinkJoin {
        name = "unity-with-iniparser-config";
        paths = [
          (fetchFromGitHub {
            owner = "throwtheswitch";
            repo = "unity";
            rev = "v2.6.0";
            hash = "sha256-SCcUGNN/UJlu3ALJiZ9bQKxYRZey3cm9QG+NOehp6Ow=";
          })
        ];
        postBuild = ''
          ln -s ${finalAttrs.src}/test/unity_config.h $out/src/unity_config.h
        '';
      };
    })
  ];

  nativeBuildInputs = [ cmake doxygen validatePkgConfig ] ++ lib.optionals finalAttrs.doCheck [ ruby ];

  cmakeFlags = [
    "-DBUILD_TESTING=${if finalAttrs.doCheck then "ON" else "OFF"}"
  ];

  doCheck = false;

  postFixup = ''
    ln -sv $out/include/iniparser/*.h $out/include/
  '';

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    iniparser-with-tests = finalAttrs.overrideAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    homepage = "https://gitlab.com/iniparser/iniparser";
    description = "Free standalone ini file parsing library";
    changelog = "https://gitlab.com/iniparser/iniparser/-/releases/v${finalAttrs.version}";
    license = licenses.mit;
    platforms = platforms.unix;
    pkgConfigModules = [ "iniparser" ];
    maintainers = [ maintainers.primeos ];
  };
})
