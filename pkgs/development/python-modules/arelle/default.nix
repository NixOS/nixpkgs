{ gui ? true,
  buildPythonPackage, fetchFromGitHub, lib,
  sphinx_1_2, lxml, isodate, numpy, pytest,
  tkinter ? null, py3to2, isPy3k,
  ... }:

buildPythonPackage rec {
  pname = "arelle-${version}${lib.optionalString (!gui) "-headless"}";
  version = "2017-08-24";
  name = pname + "-" + version;

  disabled = !isPy3k;

  # Releases are published at http://arelle.org/download/ but sadly no
  # tags are published on github.
  src = fetchFromGitHub {
    owner = "Arelle";
    repo = "Arelle";
    rev = "cb24e35d57b562a864ae3dd4542c4d9fcf3865fe";
    sha256 = "1sbvhb3xlfnyvf1xj9dxwpcrfiaf7ikkdwvvap7aaxfxgiz85ip2";
  };
  outputs = ["out" "doc"];
  patches = [
    ./tests.patch
  ];
  postPatch = "rm testParser2.py";
  buildInputs = [
    sphinx_1_2
    pytest
    py3to2
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
