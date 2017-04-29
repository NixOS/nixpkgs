{stable=true;
hashes=builtins.listToAttrs[
  {name="baloo";value="0p3awsrc20q79kq04x0vjz84acxz6gjm9jc7j2al4kybkyzx5p4y";}
  {name="kde-baseapps";value="1nz6mm257rd916dklnbrix4r25scylvjil99b1djb35blx1aynqj";}
  {name="kdepimlibs";value="1mv8k0wr0wr0hnlb1al50nmz8d77vbm73p2hhipipgliq6zb3vb5";}
  {name="kde-workspace";value="00bf708i0vzl47dgcr8mp61n7k0xjzqnlb8j1smliy5bydiaa86g";}
  {name="kfilemetadata";value="0wak1nphnphcam8r6pba7m2gld4w04dkk8qn23myjammv3myc59i";}
  {name="libkcddb";value="0xrmg53p5lh4ral2l5zh96angaf9czhih3zzvwr9qr9h9ks5vrn1";}
  {name="libkdcraw";value="0ksarwq8aaxc77cp0ryfnw1n311wkykzdlhj03rln8jjlbdm3j3q";}
  {name="libkexiv2";value="1z8fmxfphx7szf4a17fs7zfjyxj6wncbvsphfvf6i5rlqy60g1y4";}
  {name="marble";value="1w603miykq0s84jk6j17b7pg44rd4az0dhzgq7j7d6dfcz7nfrjd";}
  {name="okular";value="0ijw71vkk1lj873hqczc23vllhkc9s0miipsbllxblx57rgi5qp6";}
  {name="pykde4";value="1z40gnkyjlv6ds3cmpzvv99394rhmydr6rxx7qj33m83xnsxgfbz";}
  {name="svgpart";value="1bj9gaaj6nqdgchmqnn381288aqw09ky0kbm1naddqa82pk196f6";}
];
versions=builtins.listToAttrs[
  {name="baloo";value="4.14.3";}
  {name="kactivities";value="4.13.3";}
  {name="kde-baseapps";value="4.14.3";}
  {name="kdepimlibs";value="4.14.3";}
  {name="kde-runtime";value="4.14.3";}
  {name="kde-workspace";value="4.11.14";}
  {name="kfilemetadata";value="4.14.3";}
  {name="libkcddb";value="4.14.3";}
  {name="libkdcraw";value="4.14.3";}
  {name="libkexiv2";value="4.14.3";}
  {name="marble";value="4.14.3";}
  {name="okular";value="4.14.3";}
  {name="pykde4";value="4.14.3";}
  {name="svgpart";value="4.14.3";}
];
modules=[
{
  module="kdemultimedia";
  split=true;
  pkgs=[
    { name="libkcddb";  }
  ];
}
{
  module="kdegraphics";
  split=true;
  pkgs=[
    { name="libkdcraw";  }
    { name="libkexiv2";  }
    { name="okular";  }
    { name="svgpart";  }
  ];
}
{
  module="kdelibs";
  split=true;
  pkgs=[
    { name = "baloo";  }
    { name = "kfilemetadata";  }
  ];
}
{
  module="kdeedu";
  split=true;
  pkgs=[
    { name="marble";  }
  ];
}
{
  module="kdebindings";
  split=true;
  pkgs=[
    { name="pykde4";  }
  ];
}
{
  module="kde-baseapps";
sane="kde_baseapps";  split=true;
  pkgs=[
    { name="kde-baseapps"; sane="kde_baseapps"; }
  ];
}
{ module="kactivities";  split=false;}
{ module="kdepimlibs";  split=false;}
{ module="kde-workspace"; sane="kde_workspace"; split=false;}
];
}
