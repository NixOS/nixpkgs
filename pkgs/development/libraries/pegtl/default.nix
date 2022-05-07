{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "PEGTL";
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "taocpp";
    repo = "PEGTL";
    rev = version;
    sha256 = "6BfWN8IsfAJxlhkFs8yCK0o2OfLI/acGXY+349MY9CY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = with lib; {
    description = "Parsing Expression Grammar Template Library";
    homepage = "https://github.com/taocpp/PEGTL";
    license = licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
