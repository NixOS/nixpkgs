{ fetchFromGitHub
, buildPythonPackage
, rustPlatform
, setuptools-rust
, numpy
, fixtures
, networkx
, libiconv
, stdenv
, lib
}:

buildPythonPackage rec {
  pname = "rustworkx";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
    hash = "sha256-d/KCxhJdyzhTjwJZ+GsXJE4ww30iPaXcPngpCi4hBZw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-imhiPj763iumRQb+oeBOpICD1nCvzZx+3yQWu1QRRQQ=";
  };

  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [ numpy ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  checkInputs = [ fixtures networkx ];

  pythonImportsCheck = [ "rustworkx" ];

  meta = with lib; {
    description = "A high performance Python graph library implemented in Rust.";
    homepage = "https://github.com/Qiskit/rustworkx";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
