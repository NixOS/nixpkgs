{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, makeWrapper
}:

buildPythonPackage rec {
  pname = "hjson";
  version = "3.0.2";
  format = "setuptools";

  # N.B. pypi src tarball does not have tests
  src = fetchFromGitHub {
    owner = "hjson";
    repo = "hjson-py";
    rev = "v${version}";
    sha256 = "1jc7j790rcqnhbrfj4lhnz3f6768dc55aij840wmx16jylfqpc2n";
  };

  nativeBuildInputs = [ makeWrapper ];

  pythonImportsCheck = [ "hjson" ];

  postInstall = ''
    rm $out/bin/hjson.cmd
    wrapProgram $out/bin/hjson  \
      --set PYTHONPATH "$PYTHONPATH" \
      --prefix PATH : ${lib.makeBinPath [ python ]}
  '';

  meta = with lib; {
    description = "A user interface for JSON";
    homepage = "https://github.com/hjson/hjson-py";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
