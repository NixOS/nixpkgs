{ fetchFromGitHub
, lib
, stdenv
, cmake
}:
stdenv.mkDerivation rec{
  pname = "magic-enum";
  version = "0.8.2";
  src = fetchFromGitHub {
    owner = "Neargye";
    repo = "magic_enum";
    rev = "v${version}";
    sha256 = "sha256-k4zCEQxO0N/o1hDYxw5p9u0BMwP/5oIoe/4yw7oqEo0=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib;{
    description = "Static reflection for enums (to string, from string, iteration) for modern C++";
    homepage = "https://github.com/Neargye/magic_enum";
    license = licenses.mit;
    maintainers = with maintainers; [ Alper-Celik ];
  };
}
