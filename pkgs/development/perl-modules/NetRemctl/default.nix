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
    cd perl
  '';

  buildInputs = [ remctl ];

  checkInputs = [ TestPod ];
}
