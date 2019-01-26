{ gui ? true,
  buildPythonPackage, fetchFromGitHub, lib,
  sphinx, lxml, isodate, numpy, pytest, openpyxl,
  tkinter ? null, py3to2, isPy3k, python,
  ... }:

buildPythonPackage rec {
  pname = "arelle${lib.optionalString (!gui) "-headless"}";
  version = "18.3";

  disabled = !isPy3k;

  # Releases are published at http://arelle.org/download/ but sadly no
  # tags are published on github.
  src = fetchFromGitHub {
    owner = "Arelle";
    repo = "Arelle";
    rev = "edgr${version}";
    sha256 = "12a94ipdp6xalqyds7rcp6cjwps6fbj3byigzfy403hlqc9n1g33";
  };
  outputs = ["out" "doc"];
  patches = [
    ./tests.patch
  ];
  postPatch = "rm testParser2.py";
  buildInputs = [
    sphinx
    pytest
    py3to2
  ];
  propagatedBuildInputs = [
    lxml
    isodate
    numpy
    openpyxl
  ] ++ lib.optional gui [
    tkinter
  ];

  # arelle-gui is useless without gui dependencies, so delete it when !gui.
  postInstall = lib.optionalString (!gui) ''
    find $out/bin -name "*arelle-gui*" -delete
  '' +
  # By default, not the entirety of the src dir is copied. This means we don't
  # copy the `images` dir, which is needed for the gui version.
  lib.optionalString (gui) ''
    targetDir=$out/${python.sitePackages}
    cp -vr $src/arelle $targetDir
  '';

  # Documentation
  postBuild = ''
    (cd apidocs && make html && cp -r _build $doc)
    '';

  doCheck = if gui then true else false;

  meta = with lib; {
    description = ''
      An open source facility for XBRL, the eXtensible Business Reporting
      Language supporting various standards, exposed through a Python or
      REST API'' + lib.optionalString gui " and a graphical user interface";
    homepage = http://arelle.org/;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };
}
