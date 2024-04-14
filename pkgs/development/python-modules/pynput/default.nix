{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
, setuptools-lint
, sphinx

# dependencies
, xlib
, evdev
, darwin
, six

 # tests
, unittestCheckHook
 }:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.7.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "moses-palmer";
    repo = "pynput";
    rev = "refs/tags/v${version}";
    hash = "sha256-gRq4LS9NvPL98N0Jk09Z0GfoHS09o3zM284BEWS+NW4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'sphinx >=1.3.1'" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-lint
    sphinx
  ];

  propagatedBuildInputs = [
    six
  ] ++ lib.optionals stdenv.isLinux [
    evdev
    xlib
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices
    Quartz
  ]);

  doCheck = false; # requires running X server

  nativeCheckInputs = [
    unittestCheckHook
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A library to control and monitor input devices";
    homepage = "https://github.com/moses-palmer/pynput";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nickhu ];
  };
}

