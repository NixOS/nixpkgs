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
  version = "0.4.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "darsor";
    repo = "PeakRDL-rust";
    tag = "v${version}";
    hash = "sha256-9OEzfIvuVilbFlv0z07S6b7wVM95e+vdcDU8MphRlao=";
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
