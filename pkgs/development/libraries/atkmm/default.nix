{ stdenv, fetchurl, atk, glibmm, pkgconfig }:

stdenv.mkDerivation rec {
  name = "atkmm-2.22.7";

  src = fetchurl {
    url = "mirror://gnome/sources/atkmm/2.22/${name}.tar.xz";
    sha256 = "06zrf2ymml2dzp53sss0d4ch4dk9v09jm8rglnrmwk4v81mq9gxz";
  };

  propagatedBuildInputs = [ atk glibmm ];

  nativeBuildInputs = [ pkgconfig ];
}
