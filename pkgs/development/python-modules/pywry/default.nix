{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, pytestCheckHook
, pkg-config, rustPlatform, cargo, rustc, libiconv, Carbon, WebKit, setproctitle
, webkitgtk, glib, AppKit }:

buildPythonPackage rec {
  pname = "pywry";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m9iMNqsIYHKNnmQ2ABD4q87eQ2RWVgMOSmPmnoGpjJU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-rC/PIoUWumJ+BvEfreAAM8QKDLLDJZSEgCs1mCTV2Uo=";
  };

  preBuild = ''
    # Hardcode path to pywry binary as `find_pywry_bin` logic is not aware of how nix works
    substituteInPlace python/pywry/backend.py \
      --replace '"""Find the pywry binary."""' "return Path(\"$out/bin/pywry\")"
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.isLinux [ glib webkitgtk ]
    ++ lib.optionals stdenv.isDarwin [ AppKit Carbon WebKit libiconv ];

  propagatedBuildInputs = [ setproctitle ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pywry" ];

  meta = with lib; {
    changelog =
      "https://github.com/OpenBB-finance/pywry/releases/tag/${version}";
    description = "PyWry Web Viewer";
    homepage = "https://github.com/OpenBB-finance/pywry";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
