{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "imagesize";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0msgz4ncp2nb5nbsxnf8kvxsl6nhwvc3b46ik097fvznl3y10gdv";
  };

  meta = with stdenv.lib; {
    description = "Getting image size from png/jpeg/jpeg2000/gif file";
    homepage = https://github.com/shibukawa/imagesize_py;
    license = with licenses; [ mit ];
  };

}
