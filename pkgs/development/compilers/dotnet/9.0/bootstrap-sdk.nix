{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.16";
      hash = "sha512-g6qC+SsAm4ne7MNM3FnE7UJhfnYfPZCnuiQ9hdfqroA8p0hbtTTfrnXfotKuB1dorcFdHxzxmF/y7B6/332lBA==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.16";
        hash = "sha512-l/TH0hGFWxQKbqOTtAWcS/eoB2J3o9feUElDx0QuePAI3sQzdYiG0Pcpnxi7gPvdVGZ3XXm1ymapRQFDlqiKpA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.16";
        hash = "sha512-7qUQcLOkXgeOxzMy//Xf2W9ZLAHzxowuIZFoEj59JMeCIzazpcVEpBsJOieKjY+NvHvqtTUIe5aHAU3c+CAS5w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.16";
        hash = "sha512-dLkKVuBnpOpcRw+wqzBqt+KkDhzWdZy1EpzMEN53zzGP4lcc4FlMYcr2bybVQDeKVEpl+YaPi/XFMgII2MR6FQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-/W42GWYKpSQ8e/Hm3DvHqPb2U3k+csodHY3sR5Vu1RA/0XTWnoZgQZHVi+Tm1LfK/9zG1BjO+xyj8A/pwy2kpg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.16";
        hash = "sha512-6GlOa8NjPYAbDHtYw7eS11msF5knJtv7ChgWEltuTf/kS+eoddyshx7s+N6DbLrz2JTwk4karRywdjvSCFe9OA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.16";
        hash = "sha512-rS5NYmfJTtyqfHvORAP4AadPON4xj2U/tHSFPl2G8ROhCsIkhigAz9H7IeGEkTsOdcSqGs2K46rlbkgCREVlIw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.16";
        hash = "sha512-comndu0Zdd7143KzYN1QWcLIyPfiJyY6vo0wXCF5CTN4GcTnImmETy0ciRGwA9YNM5mOCvgff274GBYNT7mcHA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-pIWCDQKACuUR+AV2WlRWiQBqWdNag0IW9s00Ov3pjzeaxBRz/VUL0eJbq3QNsH1ATkwgeKju6PbKCnSZWpDG0g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.16";
        hash = "sha512-qA/7jKoGf5liZJX/8L4JPswADax2AzWmCGhffJUQLTYsoxGldFCNLEwueMUwUEUDT78e4snrW556sCBHfFaBEg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.16";
        hash = "sha512-3N29ax8qp1B96EN+6hOnb7sRoXhW9ZZV/WITLx1SZb8ZNvaxO2bEyPgWL8uMWLO7YeSG6/7zUt/Yf6oM94k1YA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.16";
        hash = "sha512-qqxHz2W/ndbUSoOOqrKdh7QbYN1cfNQqbPWzTilcIajdEo590hAFwFmZ3CS/tTXtc481VsudErLQRNeRcPDbtQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-i9UdvTipMhDnMX5/dIvpmL56uP+UT/+zvF45O3VEnzwwwJlRVkvZwv0glF6ZSMrk30e4Cfj1WMppibdcUkbuDw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.16";
        hash = "sha512-42ropbvF7wZPRGznJxX8fHeDcebfb6VO65VxkkSLaCSt1cfB1dBOw8N57hjmE/KXBOUQyI3ObQkSGhXXI2ILdQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.16";
        hash = "sha512-HVV6epuG3QjICjwMESQZErZA99TUYMsaCFWu+5kL6nN5EoTCGUfKfsGhHK/RFjIPS/P+NJZMjTs4669csMaDhg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.16";
        hash = "sha512-NcZUYP1DNy5oYxl6L6HnR7cGnlKxmX1WQrZvQgS6/PWZoG4vNv2+o+HgYWaBmOkrlyu+QP2MiBNQiT/gEp7E+w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-HyIg3hOnPf43b/0berINQBgszML4eW5AYsjlRUl6IdAu5JPA9mttssdExgi3uAF/5RVyZeiFO2aQ1vlJO0/2fg==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.16";
        hash = "sha512-d7agtf78EsZNcxLvbOh2n28diFwTL1VCCAqZGBE5PXkbbpsygJQRMLHSAH/fOTrvhfgyI3vFPLtvS08hS1FkXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.16";
        hash = "sha512-ifv4wiafNTemDz1XSvZQuVVsNJ8m9YiYLEjKOjHVBEqIYt9//I/4IHxTCosm2KsWuXTyEyvMX8n3BKhSlqSH4Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.16";
        hash = "sha512-pWIHo7rd773ekgHa57Ef2u+5axd0tB1p6xlnZaVW0yu23KBxK/MnNN+3AA2+iqWHvg0O/aOfqBgXYFeoU9JFwQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.16";
        hash = "sha512-oUaAC24zXXYfIRwGfjGPQ5/l/ZOdY0GL0+8SaSgM5B7ajh18mWr4OwGtPhlh8LkKwM347VKovEoKRDgEgpsFkQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.16";
        hash = "sha512-5kvqOZkWpE19apTQ2TOvnHkxx1lO5LDJMsKGiNdG+sCo+3jMSXd5nuaIH54XHORPN76a6Thq38UrRkhEA5qQgA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.16";
        hash = "sha512-EMfad0WhkbIL33XTMpevCl0zoIHjHqcA1zb8cuoUGg3JiLe351nMVfvAPCSG8bVD2X7SXP9R7YhKNoY9Dnx+lQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.16";
        hash = "sha512-Ip0Z469HQcuY0XULqc86HXuUFdk9bxUK/m+1zlWiq8Ar01JlNV7Wcvlv9stEnUMwiiiQZu46p0CW0rJgbgMveQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.16";
        hash = "sha512-7qgycW7MWpOF3sp8xVA7REnggj/xQnDkdy4igkUnyL/UFR/wuH4M92ET0tPBBIZNALALGW735PlDMP+0ZXqrFg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.16";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.16";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-linux-arm64.tar.gz";
        hash = "sha512-hfJBz4m49vsfl7RS4Q0Z4vAh+eWV7t00Ld/tijpTWWpSg+G2teSefh1nwqA8+lJhWDXjx88AY57UCwgsTkKd/w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-linux-x64.tar.gz";
        hash = "sha512-AMDHOl08pWB9jh2wIECaIBvLQkaeTk9/uZKpnoqO+kFlfowr0pyZzB+XMx0LR7t1JWR52UU2SWIaOsoYogL0jg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-osx-arm64.tar.gz";
        hash = "sha512-Pq8eoSL/iJQK3+AT1srygW7lcID2gPrZUZCO6ask8IJQ0RGRofLfbcZulEUUHa4kjosxQlhgKpB1Pk4cB7rxOw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-osx-x64.tar.gz";
        hash = "sha512-klLaNvNSlBKraeF+VEeCik0Lnof8TY5SKOdGNLBVKpA8IbfChr42xMO2KEkd1OZFiQnIpT7HDB8MBBBmfN2HrA==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.16";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-linux-arm64.tar.gz";
        hash = "sha512-7yrr47d1WXPsWpAHxYD8l0ZCnd8FS996wQexsB68vtqtGZYC8WyeYv306wqgK6S863sa9sVzctCeMhpAxDe3vg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-linux-x64.tar.gz";
        hash = "sha512-M+AI6+tEdk4HQJpkYKdFL/TOWZ0HYWOztjju2f/wdY/TVXtjgoJFlZxDylSsD94NSq6ZAAvVdXeBVXIlK98nqQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-osx-arm64.tar.gz";
        hash = "sha512-jJ1ChUU6CptBivBohEgLjqH03RgQGTMLIBOSvp9TYiMr4/lhJOq4yqEo0du+t7HJ4J6YJuLKXuBW0h6fShd7sA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-osx-x64.tar.gz";
        hash = "sha512-IQyotMboBjaU88A9E6vcZezMI5ZvF2gGdpe0waK0C8PjFOQUoIt9CgBmFE937izI7jwdcyZmSSpR/yJDOoaaUw==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.117";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-linux-arm64.tar.gz";
        hash = "sha512-BVeI2RNXCcolRB+AP+mAHNMyfYx8pCRO6IKKLwwxLCFcrxVb8+LvKgcAS5iB2ogGEKAQ5mByhNVljofDtRVONQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-linux-x64.tar.gz";
        hash = "sha512-f//fJ8eA+ud5M7iH/WQJFm2c/1SKJsK4coWm8NwSb+sekQohTp1yZxfkTU2/bWkzbnkuYIWwjK2EPXs62fTp2A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-osx-arm64.tar.gz";
        hash = "sha512-najG1azrmoCTgThZKMwGMChmHBX7nAFmKpL3lpRFerX7oDT9pBlCm6sDMD58kLRwOlw394+nNkzR5VH6GleDQQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-osx-x64.tar.gz";
        hash = "sha512-aBtK+/6Vdm9MinaUy0OCQHFGlBt7QfNhbFfYDBDBCigbn5jg+SSJ05agksYgguFVN5wnB9KacLB1vI2k4eLNrw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
