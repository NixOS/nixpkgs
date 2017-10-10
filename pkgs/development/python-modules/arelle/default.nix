{ gui ? true,
  buildPythonPackage, fetchFromGitHub, lib,
  sphinx_1_2, lxml, isodate, numpy, pytest,
  tkinter ? null, isPy34,
  ... }:

buildPythonPackage rec {
  name = "arelle-${version}${lib.optionalString (!gui) "-headless"}";
  version = "2017-10-07";

  # Import semantics have changed in python 3.5. Upstream uses python 3.4.
  disabled = !isPy34;

  # Releases are published at http://arelle.org/download/ but sadly no
  # tags are published on github.
  src = fetchFromGitHub {
    owner = "Arelle";
    repo = "Arelle";
    rev = "55d9a570aae3fd2f332eeb0741f66abeca8bc489";
    sha256 = "0ld5h4s1dj96fy09hns6f9mw5gwq9pjfsy7jc1f5prif5g3smmnw";
  };
  outputs = ["out" "doc"];
  patches = [
    ./imports.patch
  ];
  postPatch = "rm testParser2.py";
  buildInputs = [
    sphinx_1_2
    pytest
  ];
  propagatedBuildInputs = [
    lxml
    isodate
    numpy
  ] ++ lib.optional gui [
    tkinter
  ];

  # arelle-gui is useless without gui dependencies, so delete it when !gui.
  postInstall = lib.optionalString (!gui) ''
    find $out/bin -name "*arelle-gui*" -delete
  '';

  # Documentation
  postBuild = ''
    (cd apidocs && make html && cp -r _build $doc)
    '';

  doCheck = if gui then true else false;

  meta = {
    description = "An open source facility for XBRL, the eXtensible Business Reporting Language supporting various standards, exposed through a python or REST API" + lib.optionalString gui " and a graphical user interface";
    homepage = http://arelle.org/;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ roberth ];
  };
}
