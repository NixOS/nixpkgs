{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0"; hash = "sha256-aJGomnD1okC2jNgNKf2m1S+OzkoAOojSdFm6vwDGMrI="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-6vkkplrniPAITExi+5RKWwHqN3S3TRoRLrFgbBZJgao="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0"; hash = "sha256-vGJULi9QN90IgieY4NwjmY5p4nV9UoiEqMND+blZrXs="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-1DTOB+GEeDoeh9H1Q09OR3fXFQn0lniBTRyDsVN+gUY="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0"; hash = "sha256-23+lxHpxVh7Me942mSjHxQIdR6akX06ZKAUp3oziJ+w="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0"; hash = "sha256-Gq7yqYvtrclou5R70ZT842nMG0mzdYojlvflVurpKWk="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0"; hash = "sha256-0k+Gf0H4y52A96Dth9tapfon1ufP6loL6fkkMq3fCf4="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-6K4hYOQ9jasxZvHu4gy4mGRiDE4mKSeSkxQVvFHuC5A="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0"; hash = "sha256-NcPd4GYxgCmqazHFLRJUlt2ksg6FqZIPSHcRj5Hvibg="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-3xkJe6dOfJnG4LhN/147lFFDekYujwPwP0OknKH0wmc="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0"; hash = "sha256-DgKJxZuPRhUOXQ05e1xhp/bP30iGKGXjwipmzGNuPJU="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0"; hash = "sha256-YAG20covZN6Pox2/Li1pzUOOFCW3LAaIjnnuIWY0Ntk="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-3bDVSoO1BqjrTLgR1/Dtql9iRH1I7OXKVAnuavsPOSU="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0"; hash = "sha256-kxhyPNoTLQu/a3vOYALsP/HUMrieqn0X7glL3sMM9sg="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-ebeq3KZkwiboc8y1kYCX6jhvJXOGMpWhHtn0YKOVFis="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0"; hash = "sha256-DqmdpH+O5y7htsrMB/hK2+N/D7IGnk2p39lbiFgi/Is="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-WLJA9CoDVdUpP9Pgv6Tg1xi7YHjneY8gPdOLiEHF/r8="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0"; hash = "sha256-IKy1xaFtnbc8+ZTAoBYxQPlws1vG9YYMk5Ce9xyR+6c="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-dkEUTvOMkz3kBPYhFLot1Vv9rOoajkusCTjuX/MMXrs="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "9.0.0"; hash = "sha256-LkxEwudPwExS68+jPQ9jt9NBPsvJBI+o9i4PTnjwnTc="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-RbzyuZPt9G/crriD1MEioT/s604M5nP652FNWuoqL5Y="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "9.0.0"; hash = "sha256-fgNqrcYYbgZa84UMe7e5qnHGt5PaSUvDFeL55GZyb7c="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha256-QWcTXTVQcF9RwhT8S6BhNWzbzfWe3dS7OTVVT8SX304="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "9.0.0"; hash = "sha256-gPukpIxEZCMIP/7T7qFEKcytr1fzRLvG9JmW5VGvFN4="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0"; hash = "sha256-Lwdf0fk3B+IXYXY4gghXMvkBOk/09ywYIQDgpa+Demc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0"; hash = "sha256-FQTY4rdm//kHJ+Oduz493NWB8p/o2WHJ4cS6YZJ/mYQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0"; hash = "sha256-MIBr8MIb5OmtMCjMgu+VBGslXkS4DRwMVwZxYAZF0V4="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-mA6m0KbiUUBZTlmWpvRJPty+lCMk8CBGHbjoqkOpmCk="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0"; hash = "sha256-pH3r9CoZPFBgfl3waWOn9B4DHeszxI1h/cU+emwires="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0"; hash = "sha256-Paml8OXMgISO+RsWgqwRV3/2Quh2RpGWBDS+dT+U3xo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0"; hash = "sha256-YmqIy/Hr3/mQRXnCyC4rf+goOyGSflUHkiChxaX9lSs="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-sEZP/ICnWZ5cRiJiw6q0vMJ/bQwe5gH1ewU74Gd6VA0="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0"; hash = "sha256-4VhYI4XJ0XyKlRju6r/8wvf9xfJGtBcdadAv8Cr/OcY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0"; hash = "sha256-h/AwNA+RqXvjY4ovLtaLnB90ThgqLFx6JaaFTz5hhIQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0"; hash = "sha256-jfCFsvpF16NHB2zmwenOJgP7vx0gzx3KhszaxZE/KCk="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-KbnZL95bqKPmXH6bGGzVmdtsqLlcQn9NaAl3rmNPen8="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0"; hash = "sha256-x0D0514TWRJd/JYyuK1TsruxH2a9KT8wMKjLwgpHHVE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0"; hash = "sha256-+uuNcxqLlfVxN/gnritlGgDPiJGbDNWlEeW276OfTq4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0"; hash = "sha256-d+IaDfaOqe2pbOyGzFK2y13lSh5sz6CRr4NFlgz9f9U="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-4cT9hwwMcfTOCnF5aKjJ4C112B+JDg+6cpLTXbZskbg="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0"; hash = "sha256-YaiHzpa9KC4B6gHD1J5spNuF4gjYQ4AWDlflwWmPW60="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0"; hash = "sha256-aSMFHSDezMkAautCXEK6cqGc0moXZnk8BuqnGmCGeM8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0"; hash = "sha256-BW+MJAePklAK9RodIY0qp4UhfYhXeDfbod2ZxjPMan8="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-WeS7VC2zrPKwhDD9gs/yu1FKowTDE73+oH2HwBlo1jY="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0"; hash = "sha256-6+v7COtoF3kJfVa0bxCZl2xtyuM0dfA1Fpl8PEFp3n4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0"; hash = "sha256-h5yg6TkEIHuBYpvjlYy9Dnj7ieGM35ieaG/wPXBaP3o="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0"; hash = "sha256-CoLNg3C+Lk4QitMEqo9dFzoI/ImDPmOYBRnFLseqPxw="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-AddaDbsZ49MEbhiy+6tA8moMLBDkPPQibxWJOApO+LA="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0"; hash = "sha256-2C1VtQW4/E5r/wuOIICtxDQxEkEKUvNVGgbffyP7rHM="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0"; hash = "sha256-AtTS8u4zYvfaq2BfGsLb4zuWh/ze+vn+VLlMb5LYfyA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0"; hash = "sha256-zJwrDlc7r+JlbWSUIxTBHAbi0w+hygBxhE7GLIszSQY="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-eoG/O9D2CWJgfFhbQ5FVrkkYLy9RYMidBxCBL12sj7w="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0"; hash = "sha256-TUtOUYYyImzY3IBY+OO5ykDhQCiX2EAeS0rv3fsTLjw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0"; hash = "sha256-PGbKJiG8zKdBI3zBysmAYR5SY4BlacfrX0P9/HaDy+A="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0"; hash = "sha256-lEH+uQPMxscIFs90Bkhdclmx3k4z9YRWw1gCcCIiXTI="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-aVzlheIRfKs70k0IWLKNzb7R+OcYr+RFYR1USt52nws="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0"; hash = "sha256-8c708mKIUG8Ko8AVuj/VhXyeiR5L2m2Nvxz2o/DDFa0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0"; hash = "sha256-Qju/5Cn+xzUxtK7cXz5StQQ1dmuk5kKfGw8/n7vmN1k="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0"; hash = "sha256-1joejVVBIh3PPqQvZ5sT1NBFzsgeraYfeT2Gj/5B6iY="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-RFd9LoK3dOzMswUQyutYB6m4jHq3tDrfge1ZnVTzPwc="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0"; hash = "sha256-QBb7aDy7Fx9nvAOI8CQHJgqYoiqgIQzfurZjC7hevh0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0"; hash = "sha256-tiI+4iRWXx2mAj2BW+OYNq4EX8+u+23CglANYHAmS5Q="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0"; hash = "sha256-Ul+5rNshfMQy853OSNQGIzEMCBz8MyqMiPGIOkbksZM="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-CKLE2pgGx9QmQgYjC+so5Ts1Z0mc8u4LKvtNWw7mAbY="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0"; hash = "sha256-NGVNZNeUk/PhKR0c+AEC4Fx/JP/9abYkNXpmdaoql/0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0"; hash = "sha256-+TzvQTQ+hpN3yqI8h2iq8M7JOqOELNHsm3gv9DVCmn8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0"; hash = "sha256-DBWaPePgbP8MIcMkSt3URroIOPFoBPmdHxfLVbgJWVE="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha256-TR9dAYG1kUoAROvS8vtCIdevFr//lb8z+yYhS94HnhM="; })
    ];
  };

in rec {
  release_9_0 = "9.0.0";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/84aa8e86-c6a1-4562-84f3-828e836ef26c/96772a224b9ff3be8904b63f37d7cf63/aspnetcore-runtime-9.0.0-linux-arm.tar.gz";
        hash = "sha512-9xGvH9F/aXbZhgn+ujLbyLAn47hRQ5qw1aaAgrpvqH7jiIz9jN02i5D8OzcQIgvi3phkq1ApfjeXrcS8uqt+mQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b2029a3e-c67e-4905-ad1f-08b164322520/bd68ea0b77f12df21b935da338fdaf25/aspnetcore-runtime-9.0.0-linux-arm64.tar.gz";
        hash = "sha512-1d9LVJpZyLmyvO5eD/qf3oH8PfdLKZq0mCCva8DM+4nuw3FOpVj/zdKhaCGk0ezcxk6ZgYBJeO4/8dREuBJWgQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e4791376-b70d-431f-bd98-5397c876b946/64ffc29a4edc8fd70b151c2963b38b09/aspnetcore-runtime-9.0.0-linux-x64.tar.gz";
        hash = "sha512-GoECPxGd1eWw+dh7DjxC34mCS5/LcxkqRnDMLGc1jNAYp8nJZSRceIPeRovaiMgdZKIcYPm8aKZVnXbzLTTOlg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/59a041e1-921e-405e-8092-95333f80f9ca/63e83e3feb70e05ca05ed5db3c579be2/aspnetcore-runtime-9.0.0-linux-musl-arm.tar.gz";
        hash = "sha512-lVjIczCM4nWjZ2Q9lTJxrIh34MNTX8FxfO8BPsN/Qhd/AT3YdaEnGb+dHBUztRWSy4+HGV0eOY5SjuXQsE98Hg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e137f557-83cb-4f55-b1c8-e5f59ccd3cba/b8ba6f2ab96d0961757b71b00c201f31/aspnetcore-runtime-9.0.0-linux-musl-arm64.tar.gz";
        hash = "sha512-+1JVYZ+gwQggILdQeJ6Gk2zBoHueMhKX468zavO3911CXCD66fTdnXbAsE1ETh5t0V/VRf7sD2qRN6ZHAa1GMw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/86d7a513-fe71-4f37-b9ec-fdcf5566cce8/e72574fc82d7496c73a61f411d967d8e/aspnetcore-runtime-9.0.0-linux-musl-x64.tar.gz";
        hash = "sha512-CeNwlmTwmbQRb4oqrEs2UkfRHQ0Z7K4mKUneOPqdQcxsUhpn5bH/7NY8YQwem0FFm/sY9iudnTtRduOFbprTWw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a9c3126c-91ab-4ab1-bc0a-e6bbeee7a786/3f848ed6f804c50f3a4c24599361e0eb/aspnetcore-runtime-9.0.0-osx-arm64.tar.gz";
        hash = "sha512-SqMDfluLcj9p1Z6nM3gNzstcjhevkk2UWzaSN7/61qahHO+/tttc+y4fKB4jhayI6CUxILGlL025MYYITyMPUQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b3d48d74-e9f8-4b6c-9ef7-6f5729873f21/2139bfd7650c0fd8ddce3195ada43ae8/aspnetcore-runtime-9.0.0-osx-x64.tar.gz";
        hash = "sha512-6neKeqfuzSxGw4sYcRngr9sCUydDVQpL28VqkSXjKKCJwWr3TD/+ZJJj9FbvJvX8O5MvTR9202pHy0GfIDxlhw==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8f639af4-29e2-474e-ad2d-ad1845c09e21/d6a1fac24aa5bed41dcc8c35017a44f4/dotnet-runtime-9.0.0-linux-arm.tar.gz";
        hash = "sha512-+rVS322IQJCrofZYyIErU2npvqF+ah+QUUXN5RJ3K1fbXVz1hsbCt/Llaoy4PCBvDPdZS89C0yhEuBA1OL2IPw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3ae34de0-5928-47c4-9abb-e0b8f795c256/1ea2ed5a50af003121ebf32cb218258e/dotnet-runtime-9.0.0-linux-arm64.tar.gz";
        hash = "sha512-T5wt1USvC4VAwWNSufAfdfgouOTghAV6MApN7GUvs9ZTKQbN1CRjmcwT8WtXGxdXWBLsL5wpfie77WeLr0sv3g==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/282bb881-c2ae-4250-b814-b362745073bd/6e15021d23f704c0d457c820a69a3de6/dotnet-runtime-9.0.0-linux-x64.tar.gz";
        hash = "sha512-UXa9aGN2Rs02/Oeoj4Pv/hBl+wdebUpGuL48M9WoOUdAV38O1Pi0+xP6af6DsinrVat/RcqskISb8DkqZw7Vrw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f2566d5b-8b22-460e-86fa-94388974ab09/a4ae7832d06be1e5ef0b55ecc22b1ad1/dotnet-runtime-9.0.0-linux-musl-arm.tar.gz";
        hash = "sha512-l9wd3KwXfXO1F9ZRMm7EhOrFJQHFBsjIN8P5zq9Hbd+SnM7Om23CwKTn03hXb9c5MKiDWBRpBjGlYGQlJzNbMw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/51a64e2f-043f-460b-a048-ea79617d9a06/b3274372b27c70fc4da62cc994890f8d/dotnet-runtime-9.0.0-linux-musl-arm64.tar.gz";
        hash = "sha512-M1IzZNkxC3XZgZpIZrEgwDue95Rr02RrFZMON/8eIR3ilMipS0rWwcD30pHLcGAaQYjjltQlL1dno2ptvmhQKg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/53729aa8-9540-4ddc-ad77-4b7126b36b30/5156249a151c4d334c19c89bb63b940d/dotnet-runtime-9.0.0-linux-musl-x64.tar.gz";
        hash = "sha512-nDPXOomPqbToSuGERGi2kIaXn3wsjqazLbD+pipAFFE86gYZAl+e2yPmerSuTi8nJdHZu4koWLun3+jtF67nmQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/013e0f03-e1e4-4f97-a5cc-e6504f684620/0c0ea6a0c124d87027d8ff6abeb7b697/dotnet-runtime-9.0.0-osx-arm64.tar.gz";
        hash = "sha512-ZsSHri9fwk1bqv37QobiNzdmS9PvwYGrwxz13tYNwi5LoXkXRKUG2jQ+YDSx/Not7nYdnnEimUWhd7dQi6bdtg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4be484a1-a095-48cf-8407-cae1d3dcc944/9f373dc1d85022e004df3ac1071ace59/dotnet-runtime-9.0.0-osx-x64.tar.gz";
        hash = "sha512-Hr1ql6t0T+dSBoY51naxRZYNggUBx5J1FARQfo2CzZJo1+I5xDf53nOwgUHDtpO7JO6zzzuvMOO/M7Rgu5XUsA==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/526d93c5-bae2-4cfc-a9cf-b2d28d7b5c98/17c926df21958999f74992973837d261/dotnet-sdk-9.0.100-linux-arm.tar.gz";
        hash = "sha512-3gbonlWbx2P/Z3O8+FLZFexH8tifTnBluggA2pmrVjV/MUNzkad9cJbkBfYzGGJbDLB09rQQA2++kG/OfzeU6A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6f79d99b-dc38-4c44-a549-32329419bb9f/a411ec38fb374e3a4676647b236ba021/dotnet-sdk-9.0.100-linux-arm64.tar.gz";
        hash = "sha512-aERQ5tH3xxH//b8yorhqky0XpR9HQr0npCieMZxbJPZ0NVP8fgrRxxY+RI7VxAzR7PQZiy5oGsxGItjmGTpc8g==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/308f16a9-2ecf-4a42-b8bb-c1233de985fd/be6e87045ab21935bd8bb98ce69026c4/dotnet-sdk-9.0.100-linux-x64.tar.gz";
        hash = "sha512-f2m9oEfeH5Uihr4zCl6FgXHe2VLRqiQWnmIhL5CicUnmO2NsiK0xOm4+yGDaMfjFR/9KtoCBA6Bw9/smupnBxw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c77904f4-57f5-46cf-bf99-d0dd1e4b9b3b/d7b454d3500c1a930b38e39a916aa38f/dotnet-sdk-9.0.100-linux-musl-arm.tar.gz";
        hash = "sha512-sJIPgOhmp2A86mKKETDfADvF14GCdciliCoxxuTinwcyL8XP2HMziT5BMb2WEw+yOE0AjLrXBAIsiSZ9UmhuBw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ca5a82b7-704c-4405-bde2-4bde4b932d2e/0332e51e8d339cbc0410079f911205f3/dotnet-sdk-9.0.100-linux-musl-arm64.tar.gz";
        hash = "sha512-2uBtAHMn9vU/UMs6KIS5PNL8u3PHVqisX/ZzYX+b3wAJOTLzqDZSIR/C7rV8JxB4ZE71wopCiX2Dl/dtDolYbQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/404c65f4-7595-4792-85ab-e26084ebb5cf/db570cf4dc8d0a61270243c61fbdf619/dotnet-sdk-9.0.100-linux-musl-x64.tar.gz";
        hash = "sha512-4gMua07Zmts6krfgQeqJXuCcbtJFWh9o5V7VO9YTyMIO9KpcQ0OTu1/bwvVjWoMGf3dFH+L9P+vO4mT+B3rNqg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4569c514-16ac-49fc-ac41-4416f547c249/851fb0aa9b2a8bdcb0d1d9f9493a952e/dotnet-sdk-9.0.100-osx-arm64.tar.gz";
        hash = "sha512-lN+kllIZWohPBtBs6yPvb31zgP4MQBW5bo+VC1epVYcR+6YRKHEPnI3gCB3ZGvSKkPe9D4uQA4rrWusk+2ck/w==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/cab5bf72-f0c7-46c7-a8f2-074f71e4b6ca/a14ec2fc3b6fd32d47b4293994ab3c61/dotnet-sdk-9.0.100-osx-x64.tar.gz";
        hash = "sha512-We8yAol5arvcVzA20NG0qhkZyDFAt6NjF0q9aL5cwCUnQVRqIdRsIBWGMx9fkhF4e9GbU4G5AvO9fCJiIDRK6Q==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
