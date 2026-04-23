{
  buildPerlModule,
  remctl,
  TestPod,
}:

buildPerlModule {
  pname = "NetRemctl";

  inherit (remctl) meta src version;

  postPatch = ''
    cp -R tests/tap/perl/Test perl/t/lib
    rm perl/t/backend/options.t
    cd perl
  '';

  buildInputs = [ remctl ];

  checkInputs = [ TestPod ];
}
