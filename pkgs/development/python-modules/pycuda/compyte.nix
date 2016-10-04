{ mkDerivation 
, fetchFromGitHub
}:

mkDerivation rec {
  name = "compyte-${version}";
  version = "git-20150817"; 

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "compyte";
    rev = "ac1c71d46428c14aa1bd1c09d7da19cd0298d5cc";
    sha256 = "1980h017qi52b7fqwm75m481xs2napgdd3fbrzkfc29k085cbign";
  };

  installPhase = '' 
    mkdir -p $out
    cp -r * $out
  '';

}
