{ stdenv, lib, fetchFromGitHub, buildPythonPackage,
  six, mock, pyfakefs, unittest2, pytest
}:

buildPythonPackage rec {
  pname = "pyu2f";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
    sha256 = "0waxdydvxn05a8ab9j235mz72x7p4pwa59pnxyk1zzbwxnpxb3p9";
  };

  # Platform detection for linux fails
  postPatch = lib.optionalString stdenv.isLinux ''
    rm pyu2f/tests/hid/macos_test.py
  '';

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest six mock pyfakefs unittest2 ];

  checkPhase = ''
    pytest pyu2f/tests
  '';

  meta = with lib; {
    description = "U2F host library for interacting with a U2F device over USB";
    homepage = https://github.com/google/pyu2f/;
    license = licenses.asl20;
    maintainers = with maintainers; [ prusnak ];
  };
}
