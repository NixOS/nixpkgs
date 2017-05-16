{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "gms_v9_rc41_wear_2_0_rc6";
  name = "google-repository";
  src = fetchurl {
    url = "https://dl-ssl.google.com/android/repository/google_m2repository_${version}.zip";
    sha256 = "0gjmmzkvjp80krbak5nkmkvvs75givqbz0cvw58f6kc7i9jm12nf";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
