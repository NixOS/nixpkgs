{ stdenv
, buildPythonPackage
, fetchpatch
, fetchPypi
, unittest2
, colander
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "ColanderAlchemy";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11wcni2xmfmy001rj62q2pwf305vvngkrfm5c4zlwvgbvlsrvnnw";
  };

  patches = [
    (fetchpatch {
        url = "https://github.com/stefanofontanelli/ColanderAlchemy/commit/b45fe35f2936a5ccb705e9344075191e550af6c9.patch";
        sha256 = "1kf278wjq49zd6fhpp55vdcawzdd107767shzfck522sv8gr6qvx";
    })
  ];

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ colander sqlalchemy ];

  meta = with stdenv.lib; {
    description = "Autogenerate Colander schemas based on SQLAlchemy models";
    homepage = https://github.com/stefanofontanelli/ColanderAlchemy;
    license = licenses.mit;
    # ColanderAlchemy's tests currently fail with colander >1.6.0
    # (see https://github.com/stefanofontanelli/ColanderAlchemy/issues/107)
    broken = versionOlder "1.6.0" colander.version;
  };

}
