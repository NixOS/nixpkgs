{ stdenv, fetchFromGitHub, bdftopcf }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "cherry";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "turquoise-hexagon";
    repo = pname;
    rev = version;
    sha256 = "1sfajzndv78v8hb156876i2rw3zw8xys6qi8zr4yi0isgsqj5yx5";
  };

  nativeBuildInputs = [ bdftopcf ];

  buildPhase = ''
    patchShebangs make.sh
    ./make.sh
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/misc
    cp *.pcf $out/share/fonts/misc
  '';

  meta = with stdenv.lib; {
    description = "cherry font";
    homepage = https://github.com/turquoise-hexagon/cherry;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

