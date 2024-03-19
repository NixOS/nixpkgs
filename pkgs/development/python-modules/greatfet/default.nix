{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, future, pyusb, ipython, pygreat }:

buildPythonPackage rec {
  pname = "greatfet";
  version = "2019.5.1.dev0";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "greatfet";
    rev = "v${version}";
    sha256 = "054vkx4xkbhxhh5grjbs9kw3pjkv1zapp91ysrqr0c8mg1pc7zxv";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ future pyusb ipython pygreat ];

  doCheck = false;

  preBuild = ''
    cd host
    echo "$version" > ../VERSION
  '';

  meta = {
    description = "Hardware hacking with the greatfet";
    homepage = "https://greatscottgadgets.com/greatfet";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mog ];
  };
}
