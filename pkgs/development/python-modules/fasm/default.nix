# https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md
# https://aur.archlinux.org/packages/python-fasm-git

{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cmake
, textx
, cython
, fetchpatch
}:

let
  fetchPatchFromAur = { name, sha256 }:
    fetchpatch {
      inherit name sha256;
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=python-fasm-git";
    };
in
buildPythonPackage rec {
  name = "fasm";
  version = "0.0.2.r98.g9a73d70";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    inherit name;
    owner = "chipsalliance";
    repo = "fasm";
    rev = "9a73d70c53fbc7e9202191120836a961c97c0868";
    hash = "sha256-oC6vSpI9u8gEA2C85k00WdXzpH5GxeqtfNqqMduW5Jg=";
  };

  patches = map fetchPatchFromAur [
    {
      name = "0001-cmake-install-parse_fasm.so.patch";
      sha256 = "sha256-ZEq/hTXjCIkVkWhgCYWtRe3wftdYMNwhNC4KNnBI2Dc=";
    }
    {
      name = "0002-cmake-install-tags.py-properly.patch";
      sha256 = "sha256-OK5nXWsAzKK5ZreUCZy0maqWKrB0rpv8c2tA8zTE4U4=";
    }
    {
      name = "0003-fix-setup.py-compute-install-directory-before-outsid.patch";
      sha256 = "sha256-XBbEHi4uXiS5rCl+0aiTkQ0q/+npgyr8zHabRMMiybI=";
    }
    {
      name = "0004-setup.py-don-t-build-everything-twice.patch";
      sha256 = "sha256-TI8Ku+UIgnMNU4L4W09cSA0BC7kohXn+qGYki/EkQWA=";
    }
    {
      name = "0005-cmake-allow-overriding-ANTLR_EXECUTABLE.patch";
      sha256 = "sha256-11HnqV7nUDL3IztA9B2KnsEy1JaGzOOea269tmaLIzs=";
    }
    {
      name = "0006-cmake-explicitly-link-test-with-gtest.patch";
      sha256 = "sha256-hy0sL5INTPkkA8fdPxrw4zQA5KsSfhRIrT1HuP1BrVI=";
    }
    {
      name = "0007-ANTLR4-4.10-compatibility.patch";
      sha256 = "sha256-ZctDyp+a0m/Yr6b/Z42DBQvrKwF95GRrYaCbsFBtEz0=";
    }
    {
      name = "0008-cmake-use-native-gtest.patch";
      sha256 = "sha256-dYIjVrq+awCPblp6fV/VaTRsef7ibib+qP0ioh3dZ14=";
    }
    {
      name = "0009-Use-cmake-directly-instead-of-letting-setup.py-try-t.patch";
      sha256 = "sha256-/Ay+XjTE7MPcQg5yeo7zuKE2T/tE/P1sIMxgRYeSWNI=";
    }
  ];


  nativeBuildInputs = [
    cmake
    cython
  ];

  propagatedBuildInputs = [
    textx
  ];

  dontUseCmakeConfigure = true;

  # Broken upstream.
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=python-fasm-git#n76
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/chipsalliance/fasm/releases/tag/${version}";
    homepage = "https://github.com/chipsalliance/fasm/";
    description = "FPGA Assembly (FASM) Parser and Generator";
    license = licenses.asl20;
    maintainers = with maintainers; [ jleightcap hansfbaier ];
  };
}
