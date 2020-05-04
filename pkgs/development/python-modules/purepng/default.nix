{ stdenv
, buildPythonPackage
, python
, fetchFromGitHub
, fetchpatch
, cython ? null
, numpy ? null
}:

buildPythonPackage {
  pname = "purepng";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Scondo";
    repo = "purepng";
    rev = "449aa00e97a8d7b8a200eb9048056d4da600a345";
    sha256 = "105p7sxn2f21icfnqpah69mnd74r31szj330swbpz53k7gr6nlsv";
  };

  patches = [
    (fetchpatch {
      name = "fix-py37-stopiteration-in-generators.patch";
      url = "https://github.com/Scondo/purepng/pull/28/commits/62d71dfc2be9ffdc4b3e5f642af0281a8ce8f946.patch";
      sha256 = "1ag0pji3p012hmj8kadcd0vydv9702188c0isizsi964qcl4va6m";
    })
  ];
  patchFlags = [ "-p1" "-d" "code" ];

  # cython is optional - if not supplied, the "pure python" implementation will be used
  nativeBuildInputs = [ cython ];

  # numpy is optional - if not supplied, tests simply have less coverage
  checkInputs = [ numpy ];
  # checkPhase begins by deleting source dir to force test execution against installed version
  checkPhase = ''
    rm -r code/png
    ${python.interpreter} code/test_png.py
  '';

  meta = with stdenv.lib; {
    description = "Pure Python library for PNG image encoding/decoding";
    homepage    = "https://github.com/scondo/purepng";
    license     = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };

}
