{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, setuptools
, python3
}:
buildPythonPackage rec {
  name = "penelope";
  owner = "brightio";
  version = "0.9.2";
  repo = name;
  format = "pyproject";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "refs/tags/v${version}";
    hash = "sha256-KlbB7i009UttTp+/MaF3y9CGUkAGEQQq/W+hQYKk9CY=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/brightio/penelope/pull/17.patch";
      sha256 = "sha256-nlhqQrmih7n4cDNqCqOJn3KJLnmKvd8HfUDk7+m8xLo=";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  postPatch = ''
    sed -i -e 's/^  version = .*/  version = "${version}"/g' pyproject.toml
  '';

  # We are a script, no tests
  doCheck = false;

  postInstall = ''
    mv $out/bin/penelope.py $out/bin/penelope
  '';

  meta = {
    homepage = "https://github.com/brightio/penelope";
    changelog = "https://github.com/brightio/penelope/tag/v${version}";
    description = "Reverse Shell Handler";
    longDescription = ''
      Penelope is a shell handler designed to be easy to use and intended to replace netcat when exploiting RCE vulnerabilities.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jpts ];
    platforms = lib.platforms.unix;
  };
}
