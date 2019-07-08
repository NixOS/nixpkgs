{ stdenv, buildPythonPackage, fetchFromGitHub, six, nose, fudge, should-dsl }:

buildPythonPackage rec {
  pname = "nose-of-yeti";
  version = "1.8";

  propagatedBuildInputs = [ six ];

  checkInputs = [ nose fudge should-dsl ];

  # PyPI doesn't contain tests so let's use GitHub.
  src = fetchFromGitHub {
    owner = "delfick";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pq9bf47k0csv41vdh2g6n336p3pd11q91hj5ypk0ls3nj756gbx";
  };

  checkPhase = ''
    patchShebangs test.sh
    ./test.sh
  '';

  meta = with stdenv.lib; {
    description = "Nose plugin providing BDD dsl for python";
    homepage = https://github.com/delfick/nose-of-yeti;
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
