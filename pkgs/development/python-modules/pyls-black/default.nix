{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch
, black, toml, pytest, python-language-server, isPy3k
}:

buildPythonPackage rec {
  pname = "pyls-black";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "rupert";
    repo = "pyls-black";
    rev = "v${version}";
    sha256 = "0cjf0mjn156qp0x6md6mncs31hdpzfim769c2lixaczhyzwywqnj";
  };

  # Fix test failure with black 21.4b0+
  # Remove if https://github.com/rupert/pyls-black/pull/39 merged.
  patches = [
    (fetchpatch {
      url = "https://github.com/rupert/pyls-black/commit/728207b540d9c25eb0d1cd96419ebfda2e257f63.patch";
      sha256 = "0i3w5myhjl5lq1lpkizagnmk6m8fkn3igfyv5f2qcrn5n7f119ak";
    })
  ];

  disabled = !isPy3k;

  checkPhase = ''
    pytest
  '';

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ black toml python-language-server ];

  meta = with lib; {
    homepage = "https://github.com/rupert/pyls-black";
    description = "Black plugin for the Python Language Server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
