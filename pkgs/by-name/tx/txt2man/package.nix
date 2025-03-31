{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  gawk,
}:

stdenv.mkDerivation rec {
  pname = "txt2man";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "mvertes";
    repo = "txt2man";
    rev = "txt2man-${version}";
    hash = "sha256-Aqi5PNNaaM/tr9A/7vKeafYKYIs/kHbwHzE7+R/9r9s=";
  };

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  postPatch = ''
    for f in bookman src2man txt2man; do
      substituteInPlace $f \
        --replace "gawk" "${gawk}/bin/gawk" \
        --replace "(date" "(${coreutils}/bin/date" \
        --replace "=cat" "=${coreutils}/bin/cat" \
        --replace "cat <<" "${coreutils}/bin/cat <<" \
        --replace "expand" "${coreutils}/bin/expand" \
        --replace "(uname" "(${coreutils}/bin/uname"
    done
  '';

  doCheck = true;

  checkPhase = ''
    # gawk and coreutils are part of stdenv but will not
    # necessarily be in PATH at runtime.
    sh -c 'unset PATH; printf hello | ./txt2man'
  '';

  meta = with lib; {
    description = "Convert flat ASCII text to man page format";
    homepage = "http://mvertes.free.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
