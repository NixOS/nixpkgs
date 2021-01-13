{ stdenv
, fetchFromGitHub
, pkgs
, buildPythonPackage
, intervaltree
, numpy
, openpyxl
, parse
, progressbar
, pyjson5
, pyyaml
, simplejson
, symbiflow-fasm
, textx
}:

buildPythonPackage rec {
  pname = "python-prjxray";
  version = pkgs.prjxray-tools.version;

  src = pkgs.prjxray-tools.src;

  propagatedBuildInputs = [
    intervaltree
    numpy
    openpyxl
    parse
    progressbar
    pyjson5
    pyyaml
    simplejson
    symbiflow-fasm
    textx
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Documenting the Xilinx 7-series bit-stream format";
    homepage    = "https://github.com/SymbiFlow/prjxray";
    license     = licenses.isc;
    maintainers = with maintainers; [ mcaju ];
  };
}
