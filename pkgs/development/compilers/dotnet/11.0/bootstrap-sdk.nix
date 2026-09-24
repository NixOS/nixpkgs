{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v11.0 (preview)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "11.0.0-preview.6.26359.118";
      hash = "sha512-B5Y8ygE5httUWnVlWEi9xuJ6cs71685MADt6RAsHEtqIpBdXf+xGUEFa2gBZNw2nELcT9DBk49Nur59EfwqMAA==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-cSG1btngs34itEXMyyDiYKlHb0J4rbvQhZlZ/IgLNUKBUaPceffyTdoUqjE6GWYrsEtHa/aE9V0IVekd72QXIw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-L1mk6noKVdLIkPGq59dGyMJnQYrJPQl5Pmehc5EF6b3WHcRwpmQmCHPfmlNL9yM/73G/d7Vd3PXKLMYUVNFr1Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-bnv2fHaufKxE94x88frvBZOLjzuCzdSVH25lQ7kkLjk/02hYF96CbhO9OA30g5eFC6FMpCqGOGwBZY0K7zYMDA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-I2JKKTGSz9bPqMJHUv+uUe7GTxvnLazVfVIjAuAVukqsU7t+xqPrx1eUVU20u86BnZdfY598uQPSUbBoYTCDIA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-mrIfT7taDEhckyX8l3cQ/8mf6ZegfNalRVKrDEbPBpRUmL13NliOqJp/iRZ0BnykLnwiZ8QyfLT3ewns8kksEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-ToD6qdfnh+RhhDTa0yog9Zbjg2Y47UgD0MFEme2nEwG7HKsZ/rBUa7OecM1gcWNn+dL4uc9bC9//U0Pp+iqmZA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-gAGFxUKFmiKz68WnTPe8vCm3lYQNyeVDf6EWVVXl7WWQXZGP76Bu5hxaBnHgc4DR+mKp7RRMQvcX6dvsvwq5rA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-XKOCSIb98OQ9JNzA37ns6mwx9KVFWvMykpyvOqlTKIBPR4m81RWZlpIn9rhCJJCm94FeaRE0m6Ecov/5Kq0duw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-2D/A4vi4A6Ta2TImdii/FfZ+cbZSP9UEp3os3w6o6Xcg465hL1Dsbx84oYpnY9Uv1rmdS6OOP99YkJ+SFnC2/A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-VN3Liwcc3FOIhZoYjxUTaaMhq1ewBOAdlKOsTtaOmesYFnk3E2H56AVtuLZXFuCuDHK/iGz6IGZqUB6WPAly9w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-NwurzUCX2kD6uZDYfQMjTbyRVUmZIXptaEqNRxFn89/QffCKVx42WTlMI2IRYYytcCh5ml4M0EDbYCZsZhdeuw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-rySJl4yhQeHPThLjnAQZ74kB/9VvzMXrTnTb1WDDI5K6MoKDWUbQwYYG5RcDfznMnPEFEaxtJpD1C5ePqS9DSw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-xTY6ZHgx/10Vw/qfXk/wd5Pbrh0LSaszrGCcwHNCoxDx10JRBs0sSU/652/CJiz9j9Wkfse9tfFbsRMoX6d+4Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-sTN3hgzfRaWnz3JQJ7NR7WXITtNay8aou9NB5KRFyBrg0BlrdTmmucnltJc2yum/ftr1H/982khc4eBQ1tWKAA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-esqU7OHu6zo2bVUkPH32v9ZTmyjdnhZsvL9PxaGps3WTYNVVGX8Cj1BFxeQ1ha2pf0F4KYvhhraYYkKAcIonbQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-IqSlMjvUVbFj5DxRkVI/7yILt2QC4MS6wWIkGtaG6Ovfd/++pR7Jo3Ts8UYrXcexqo22mzPCD0IFvtVrhvYy8g==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-+HIgeI6GhAV859fMPmT0ZPFXKV8rwBPMEJeFmKier55NxsB+fQOQHmWQGa5tUXpQp/7l10nn/Ve3oUL9SI8fCA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-q663wBF9/Hmott6ASqaom76AmQQzqSDJ7Y+1vQ/n1ljEH43LpfBYI0ymyVobKr765GdhkzcGt8QaEDhXHIMu+Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-CfrFZYFGDdIZT6b8zUTbbAg2QSrxOqrFjl/qp5ty+i1pe/waXQHkyNdsAJZ/6y6AK5J4bA2TjU6lxF02rRteQg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-3b5vei6Onmx3Ne1dX58eAJxr5IvJdZ1Zi1uqq3agpIWfHXWrNreIomE0Jn0YedDU0XdGR2vHY62ZbJ6gONNC9w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-LwVTHcocVb+i51DLax1UtFIaxqMQugWt6VO9sZjd7RC0wYNZ+SY4vlp8a1UBthoN9FAmrbEZycAhDdFyXwJ8kQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-7E5CqZeyWSg4CtvqhmFPzZpNuEUG9FiUbrExs/yrKSMzpzzmwevHPjuinWEVoyBsfkVViETVovNW+m2JKydPbQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-7tzTmR9dzUyOQcGg0N6cts1r/ZN8uZ7E0a9+X7WwLfZafYN32gMQqeYQ+cA8RelYEM85SwK261czuI+4V+qa7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "11.0.0-preview.6.26359.118";
        hash = "sha512-FqkTFb6T8CiNkPeovvyzTO/zOBQvatukCKPKkyqabrqWSTxa0Y1F5TVQdhSziucrPfQ7FG/EBSGaVhCMaV5TUg==";
      })
    ];
  };

in
rec {
  release_11_0 = "11.0.0-preview.6";

  aspnetcore_11_0 = buildAspNetCore {
    version = "11.0.0-preview.6.26359.118";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-linux-arm64.tar.gz";
        hash = "sha512-va1sKKnYNfC5B6tl0u7ZaNs3SpizjSRJxxPSdkIA12qSsHiFS/UuQBEaykyaFQbT7TC4/oNT/6TapLQW7n1iRA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-linux-x64.tar.gz";
        hash = "sha512-xqRwHaW5ZvD6yOn3uqPmHFotmyNVcQYlMMaL/Myyp9dXof1KNG/+ZAPd7KaKXuTDaGG5c3KBfH1TIhshO4qQYw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-osx-arm64.tar.gz";
        hash = "sha512-RSur/NlQOEcT5tozkwtPxQA41dFHTmE1Z5/wmXm8paTjSJbmb2XvZsGSh0w587+ov152/HEEenUEsL3QdyUcfg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/11.0.0-preview.6.26359.118/aspnetcore-runtime-11.0.0-preview.6.26359.118-osx-x64.tar.gz";
        hash = "sha512-fdQMsBv1hip5TTJf1j6fF3vEBLHmHOZpd8hS11SunqaJCu0Uq1mIu/O7pmaSyksZ/KmF3kmHL6Kyr9w7G47Y/Q==";
      };
    };
  };

  runtime_11_0 = buildNetRuntime {
    version = "11.0.0-preview.6.26359.118";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-linux-arm64.tar.gz";
        hash = "sha512-mT0KX2gn5sH9UH3sVQ/h17G06oBVeguODf0QGs7UYiZI5SbrcZbFJRRnptpHuAdCAPup+MjN8JDLPmIHzh1Orw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-linux-x64.tar.gz";
        hash = "sha512-zlUwwDFN041vG4NI+932U0HO4x4F6939eQaTfHhdeZwNK5X5INBFf13lNxvQ7emN+f2MlYjuWAKYZNWZ3W4VZQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-osx-arm64.tar.gz";
        hash = "sha512-zMiRl5xay3yh27cZOWf5E+Gk584ihcse+oWUBZDZtH9ogkjUzNagRvbm4rIw7bqcrE4TyreCgEy4qu/vgrb7+g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/11.0.0-preview.6.26359.118/dotnet-runtime-11.0.0-preview.6.26359.118-osx-x64.tar.gz";
        hash = "sha512-NBZJ04R2nPpPi803RtD1dMzOmbSCQHk2RZBzv2V72pDhrk7Fr6TEF6NUP5j0BvIfiEP3Tg7+EHo+n3W+ITTu3A==";
      };
    };
  };

  sdk_11_0_1xx = buildNetSdk {
    version = "11.0.100-preview.6.26359.118";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-linux-arm64.tar.gz";
        hash = "sha512-ewhYzLnuVaaWhYAV5dW3zI9uEbkGNM3HG9dmP5vwioGfcsPqHNQZm9OkeB6ZqdOu5YzSBKl0n6Y3LmtR8UeDUA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-linux-x64.tar.gz";
        hash = "sha512-jI/Oh9UzLdanQDwWuxJPZXVOKvstiZLMwdKVmzF3X8Q/cABPMXzHJFsLY+x0lZ8TehLv69dfoMbFhlNd5O2o4A==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-osx-arm64.tar.gz";
        hash = "sha512-XYe2+sBM7NgSz1BNeKlQZEE2lRwwkGaprADQJyZ87ryYOYAcoJ3e1ONQk9N81mCqP7QL4eAkqISbut3X8RM+Wg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/11.0.100-preview.6.26359.118/dotnet-sdk-11.0.100-preview.6.26359.118-osx-x64.tar.gz";
        hash = "sha512-ISZqBThnBu8/xPaoI2CchSes+IsSKZcWaLhkwqZ/90CVOut8b8meK+eZh0kYd2dwlMx3SiqJjlK21dUZC0ZxLg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_11_0;
    aspnetcore = aspnetcore_11_0;
  };

  sdk = sdk_11_0;

  sdk_11_0 = sdk_11_0_1xx;
}
