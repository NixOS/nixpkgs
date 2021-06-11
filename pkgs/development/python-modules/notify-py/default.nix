{ lib, stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, coreutils, alsa-utils
, libnotify, which, jeepney, loguru, pytestCheckHook }:

buildPythonPackage rec {
  pname = "notify-py";
  version = "0.3.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "ms7m";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n35adwsyhz304n4ifnsz6qzkymwhyqc8sg8d76qv5psv2xsnzlf";
  };

  propagatedNativeBuildInputs = [ which ]
    ++ lib.optionals stdenv.isLinux [ alsa-utils libnotify ];
  propagatedBuildInputs = [ loguru ]
    ++ lib.optionals stdenv.isLinux [ jeepney ];

  checkInputs = [ coreutils pytestCheckHook ];

  # Tests search for "afplay" binary which is built in to MacOS and not available in nixpkgs
  preCheck = ''
    mkdir $TMP/bin
    ln -s ${coreutils}/bin/true $TMP/bin/afplay
    export PATH="$TMP/bin:$PATH"
  '';

  pythonImportsCheck = [ "notifypy" ];

  meta = with lib; {
    description = "Python Module for sending cross-platform desktop notifications on Windows, macOS, and Linux.";
    homepage = "https://github.com/ms7m/notify-py/";
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler ];
  };
}
