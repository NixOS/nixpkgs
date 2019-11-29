{ stdenv
, fetchFromGitHub
, meson
, ninja
}:

stdenv.mkDerivation {
  pname = "mutest";
  version = "unstable-2019-08-26";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = "mutest";
    rev = "e6246c9ae4f36ffe8c021f0a80438f6c7a6efa3a";
    sha256 = "0gdqwq6fvk06wld4rhnw5752hahrvhd69zrci045x25rwx90x26q";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://ebassi.github.io/mutest/mutest.md.html;
    description = "A BDD testing framework for C, inspired by Mocha";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar worldofpeace ];
    platforms = platforms.all;
  };
}
