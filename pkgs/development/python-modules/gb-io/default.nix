{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, setuptools-rust
}:

buildPythonPackage rec {
  pname = "gb-io";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "gb-io.py";
    rev = "v${version}";
    sha256 = "05fpz11rqqjrb8lc8id6ssv7sni9i1h7x1ra5v5flw9ghpf29ncm";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = "${pname}-${version}";
    sha256 = "1qh31jysg475f2qc70b3bczmzywmg9987kn2vsmk88h8sx4nnwc5";
  };

  sourceRoot = "source";

  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  checkPhase = ''
    python -m unittest discover
  '';

  pythonImportsCheck = [ "gb_io" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/althonos/gb-io.py";
    description = "A Python interface to gb-io, a fast GenBank parser written in Rust";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
