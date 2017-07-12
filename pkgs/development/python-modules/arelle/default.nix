{ gui ? true,
  buildPythonPackage, fetchFromGitHub, lib,
  sphinx_1_2, lxml, isodate, numpy, pytest,
  tkinter ? null,
  ... }:

let
  # Releases are published at http://arelle.org/download/ but sadly no
  # tags are published on github.
  version = "2017-06-01";

  src = fetchFromGitHub {
    owner = "Arelle";
    repo = "Arelle";
    rev = "c883f843d55bb48f03a15afceb4cc823cd4601bd";
    sha256 = "1h48qdj0anv541rd3kna8bmcwfrl1l3yw76wsx8p6hx5prbmzg4v";
  };

in

buildPythonPackage {
  name = "arelle-${version}${lib.optionalString (!gui) "-headless"}";
  inherit src;
  outputs = ["out" "doc"];
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

  meta = {
    description = "An open source facility for XBRL, the eXtensible Business Reporting Language supporting various standards, exposed through a python or REST API" + lib.optionalString gui " and a graphical user interface";
    homepage = http://arelle.org/;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ roberth ];
  };
}
