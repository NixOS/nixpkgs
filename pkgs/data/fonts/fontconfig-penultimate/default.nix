{ stdenv, fetchFromGitHub }:

let version = "0.2"; in
stdenv.mkDerivation {
  name = "fontconfig-penultimate-${version}";

  src = fetchFromGitHub {
    owner = "ttuegel";
    repo = "fontconfig-penultimate";
    rev = version;
    sha256 = "106sjfmxdn2cachgsg0ky3wi676x6nd14y5fcl16n82kghi3d9yf";
  };

  installPhase = ''
    mkdir -p $out/etc/fonts/conf.d
    cp *.conf $out/etc/fonts/conf.d
  '';
}
