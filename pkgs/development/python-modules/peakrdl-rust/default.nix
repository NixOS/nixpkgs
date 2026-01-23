{
  buildPythonPackage,
  case-converter,
  fetchFromGitHub,
  jinja2,
  lib,
  peakrdl,
  systemrdl-compiler,
  uv-build,
}:

buildPythonPackage rec {
  pname = "peakrdl-rust";
  version = "0.5.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "darsor";
    repo = "PeakRDL-rust";
    tag = "v${version}";
    hash = "sha256-rcVM7ljFWlEXLxG7ASXE2iZ+WYazeMFE0sgTzkviOP0=";
  };

  build-system = [ uv-build ];

  dependencies = [
    case-converter
    jinja2
    peakrdl
    systemrdl-compiler
  ];

  meta = {
    description = "Generate a Rust crate from SystemRDL for accessing control/status registers";
    homepage = "https://peakrdl-rust.readthedocs.io/";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}
