{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
}:

stdenv.mkDerivation rec {
  pname = "expected-lite";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "expected-lite";
    rev = "v${version}";
    hash = "sha256-8ILoBK36NT7+4k3SqwgIghFSVmNHHkhxgTFvrxxXTPk=";
  };

  nativeBuildInputs = [ cmake ninja ];

  doCheck = true;

  meta = with lib; {
    description = ''
      Expected objects in C++11 and later in a single-file header-only library
    '';
    homepage = "https://github.com/martinmoene/expected-lite";
    changelog = "https://github.com/martinmoene/expected-lite/blob/${src.rev}/CHANGES.txt";
    license = licenses.boost;
    maintainers = with maintainers; [ azahi ];
  };
}
