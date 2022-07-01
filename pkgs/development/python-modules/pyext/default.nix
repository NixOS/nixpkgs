{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage {
    pname = "pyext";
    version = "0.8";

    # Latest release not on Pypi or tagged since 2015
    src = fetchFromGitHub {
      owner = "kirbyfan64";
      repo = "PyExt";
      rev = "1e018b12752ceb279f11aee123ed773d63dcec7e";
      sha256 = "16km897ng6lgjs39hv83xragdxh0mhyw6ds0qkm21cyci1k5m1vm";
    };

    # Has no test suite
    doCheck = false;

    meta = with lib; {
      description = "Simple Python extensions";
      homepage = "https://github.com/kirbyfan64/PyExt";
      license = licenses.mit;
      maintainers = with maintainers; [ edwtjo ];
    };
}
