{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "smack-3_2_1";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://www.igniterealtime.org/downloadServlet?filename=smack/smack_3_2_1.tar.gz;
    sha256 = "0lljrxky66gc73caaflia2wgmlpry2cdj00bz1gd1vqrzd3pg3gd";
  };  
}
