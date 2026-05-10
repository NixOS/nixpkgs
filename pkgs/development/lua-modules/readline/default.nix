{
  buildLuarocksPackage,
  fetchurl,
  luaAtLeast,
  luaOlder,
  luaposix,
  readline,
}:
# upstream broken, can't be generated, so moved out from the generated set
buildLuarocksPackage {
  pname = "readline";
  version = "3.2-0";
  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/readline-3.2-0.rockspec";
      sha256 = "1r0sgisxm4xd1r6i053iibxh30j7j3rcj4wwkd8rzkj8nln20z24";
    }).outPath;
  src = fetchurl {
    # the rockspec url doesn't work because 'www.' is not covered by the certificate so
    # I manually removed the 'www' prefix here
    url = "http://pjb.com.au/comp/lua/readline-3.2.tar.gz";
    sha256 = "1mk9algpsvyqwhnq7jlw4cgmfzj30l7n2r6ak4qxgdxgc39f48k4";
  };

  luarocksConfig.variables = rec {
    READLINE_INCDIR = "${readline.dev}/include";
    HISTORY_INCDIR = READLINE_INCDIR;
  };
  unpackCmd = ''
    unzip "$curSrc"
    tar xf *.tar.gz
  '';

  propagatedBuildInputs = [
    luaposix
    readline.out
  ];

  meta = {
    homepage = "https://pjb.com.au/comp/lua/readline.html";
    description = "Interface to the readline library";
    license.fullName = "MIT/X11";
    broken = (luaOlder "5.1") || (luaAtLeast "5.5");
  };
}
