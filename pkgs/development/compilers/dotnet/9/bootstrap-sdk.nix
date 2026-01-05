{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.10";
      hash = "sha512-DZAx5FDPMkz/cn4IWhivgBWLnzZw4qDhnFKTnumNeNVs/2PK0lrF5TM4bKYBSEf+tBXdMVkDKcdq8NFUfj3UCw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.10";
      hash = "sha512-3EgfFYftlGJQ0GecUldlpfnuYrzYyrNhPrOBYFG+lYLvLt0n/J6FqPZr1VGd1KZOPBO51gySSA665PM7SN2LNA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.10";
      hash = "sha512-rmARXaPmhSO0WJetsDhQRJV+ksMqI8ogN/eZaxaRaPs8zucL+2CD3ePo01BlnhWjj6AuNunNZhCucxYXRQ8JmQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.10";
      hash = "sha512-KjFCN1IHZ/SOBKfyndUy9ULvqFNUMNtNlHngaFUOq65gGemr04LmqQNHt8WnfDZoJoxrSs2jygW80R2Ui2HJcQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.10";
      hash = "sha512-tG1AR2e1woas/SuydzLqA8HrAqhChedExrq1vA5FohTPa1rEKjFNuhUT/qEOYCKyvy99HeszDLdrmDsz0URu+g==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.10";
        hash = "sha512-A55fVw2zn5ES62I5NCEe6e05pcaD4XU2xYrVX3cXJsK2OpmbW3Y7kN7Wedf6zjIgD+yks0bDlIhI05ESZsFMPQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.10";
        hash = "sha512-/RhEj23nJiFv/tbazben1tUi8c5G11xe+A9SF7eQ12El+3+M9ALl/0vPz8KKg7qmNaRPS2cVOiEKWavLSjbRog==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.10";
        hash = "sha512-b2hh2Xyn2C2ygN/Tg6xKz2mjiwV8A+yzyOjC2TBwzf0r1txcy758P8i7/VgOWd7uyVNvg3Pbtiu1pcPCsa6kOQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.10";
        hash = "sha512-HY1hQ4SjivI6EbNgCpxjvGTTarZU71hU2VQsD15jsGA7eBR3uADrf1XopYzYI1IX18pJuLquJfYa2UtzAbyGKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.10";
        hash = "sha512-KdVekQRuXfBHyRfmqqMHa/oLOqCw+4d52s1lQsj8xJdtc5CHrHkAivYihb7qIAPmo0kRaKaeui8NoVN96gddvQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.10";
        hash = "sha512-eaAyvA4BRPZl4AsdwdvN5MDOMuwoZzmAjw6GVy6swTt1PJURNfJ6Imt9dHBJ02KadmN0zLF7IhC+bNoaRqqKHw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.10";
        hash = "sha512-D8rQBhJevMzdiz2vvDHNhAMG6TM4wUngbHfkd5FV7fIBzdB5WounVjXe1vAHE5ugQ0RkHi34XZUcecuap2DfQQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.10";
        hash = "sha512-oNEzffrhwQsjMPsgKn3wr8zSx4QoHEAgJo/1r2ZleGhDaf/dZqPSMYMFQSwA+/U7tc76/L4hmC0rkqAaiEZBjQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.10";
        hash = "sha512-6nLhXIm/0EfJSIWavz4HMij7tlLeg8v4PAm3ITlocSv/k2r4f2di6KFzLgVuWz8dwKbsvbdAmrFHGraOKU4IEQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.10";
        hash = "sha512-VIJCu165l2oO5EGH6nqZ+5j2sFM89jCjtqUigNe4w7lQWN1KvUdzNY1wRCP9EUj6GMy+ZDZEXykm9QdFQfpHoA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.10";
        hash = "sha512-G6JZGWnodWOaXDLNduFWjuTrDRUvKnwLQnNcXRbH/HanYxkXJcGb4FEg7T/HxG5WFzK1aSb40CRZJzs/nQ+BwA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.10";
        hash = "sha512-eS3wDIwRM6bf/vu+wBY4si7NcxedC2NnhAJdnnJaGkSb+AoK++Fh9kp4JGYx05ZCMVY+TIY12L1+53sqgquYiQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.10";
        hash = "sha512-RoVubEeoQPK930leil3c2IpHI15696sp8pTsLj5svT/GNn6gEfzEvSqfXrPYSUwB+BcCTUrAujYEeTbzsutgrw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.10";
        hash = "sha512-486rN8RueFeThh4GviVkTCIozZaXxkyVLU/jPhDRn/4Sc02nHh+M7M8lM/wSfhwB3GF/nBnIoun/G8bG4KF6rA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.10";
        hash = "sha512-8eKvQ9LXOY0c2LNesJufNdO28u2eA58jxGlZ3uR06mkUWXDO7EfXddpPYSdvux/4eHhrb6t2SCf0T6NL8eYajw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.10";
        hash = "sha512-1GfbzaQm+Oi5ZFjKcTVvckt/oRJW8j/2Ejt/RrjO4HYFU/6dejBlJ2ByGGuR44kb5pRR6h8b+x9l6XsS5qxIYw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.10";
        hash = "sha512-+K9+h7Y8go5wKq2xHchsmL7s5yRrCLoyLXeuujks7mo/3Dq8B2TITXCx1UiAhAY/zqxpcXnOygpGKdatw5Rl+A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.10";
        hash = "sha512-gLjz+tUBox/YJyZJ4mmfbgvymG3Lp73JDQXzGA8pc4DSXDWBINeI/KUC14UUvZrI8Q14tiZZhkcYPdcqEkzY0g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.10";
        hash = "sha512-CFoY9eWh9GRBWFDi/40Tf+LVBDnB6ec60Z5Mg2vVjpFo+vKDJhpVEnww1NhGfew7xPNYRDsK59sVwNBGntAT9Q==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.10";
        hash = "sha512-jukl9oaKPvLI27MCJokX8YBZKPnUdyNlYhuXk+7uUpAt8TJfVCjzOc2plLmebpAfxUyBLL3j9YBUijRRJzpoYA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.10";
        hash = "sha512-puY/SDVlMufIM7F8hwVgwghPstsw1tDx61MV/XchF9rqqFbKZqe5U3yiy9Q75rFvVWyU4nBaAC/EbJsMFTJB4w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.10";
        hash = "sha512-ge2i0IsVqaoewscMnVh1h6MbWFruFxkZh7t0FW+VdWSseKxIfqQg+7XMDd0RCZ/I4qup7JWizGY6I5Iq0wTWLg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-h4D/Hd/j1kfS3QFhGutp6mlet5lPbPcY0l8QXuVxKNN2af2ynOCiFA2mmYaEHHPNeZhO8mgQoDlvuJopH8VIRQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.10";
        hash = "sha512-34kgieVQ5KIKjCoWeruEt9SNSRORiEozianOx8Ah173B/3fMhfMo1Ltf7JL4BR4Y1J/Chz95CLfnhUww4/UAPQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.10";
        hash = "sha512-/GcghB1kxtasfUwLoUc8kUWZKu0CLyFIIawTgejBsyxeViwyHjhBBq0DruxsRcXAw8FyeIYw41i7N4s4ED07Xg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.10";
        hash = "sha512-KLWNY8+mfMvWobEE38u3i75nV3I/1DLPkmcO5nEC4wamjeJ3IcR2pNS99h4QLl4oG0U73LRWi88wPcMEliZbhA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-Pe1fX/lv+FBxo2Parlm9iirdDQoBpBGtIOfFb3AYtFcno2zmvD6ZHr6Jr0d+BRAzbEx1GveGy3mGOfUIrHziFw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.10";
        hash = "sha512-tRqIuT+Dh6ZGPW0Wj4d1xEn7KQRE+/Zf+IUzu/cedwuYL7C8hd4cFmv7GyOlE1WZLhkiv/T6O+dKCdzO4OGd2Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.10";
        hash = "sha512-tP1SxfaqZsUuLG4u4k1EOM1W8kCGZD8csKvlMe+nxGvXcE36Ba3nfJcRKdkZwaxxvIFTNCw9d8RBNC+m88IKoA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.10";
        hash = "sha512-ZFTGqSsaB+MlUtcS+nH2dsUh3gq8aD0lkzDTkwqWPGPRUjmBQ87K+UTDZGLDzUGKXhBrrsQhTIXIMPtL0JJOZQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-cpxCMDdnOY2bajyIJ+h5xpQ3VsZfFScAxcQv1pohaguaksGHJgRoWJpVDfnE3+yCwWK08ye0HbbI60NPI5vurQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.10";
        hash = "sha512-z/B8WqPhX2HBMr4S/oa80Veq7rvW7C66t7SobB2I0U5bvKST+O90rpCLvgO82S0LfhQl2E9tr+yzY7yZWcl/9Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.10";
        hash = "sha512-bg2uNWg3+Hq4JEArSnx8Ro+MycKm40OTcI8hM3Hj1mLDxHMA1vt4EvgkZrMN+rAr0Lj2apukx2fNpxGG+NSEzw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.10";
        hash = "sha512-4lVp5Jva7/DGvV6TPP4SuEO2rQkX5dlmZeTT40j7NZt2alVkKFIg2RTeTY08ufsP12N0+CIv6Kp/wZ+rl40/gQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-Z622RPpQAt6KZxKPE47xRxo4BljsmMMoT69/3Bz1ogSQzS8gZL9fggtyc2d/ULrann2ZHxRyZ1XkPEMeW6eGLw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.10";
        hash = "sha512-vBa8K8o9jB2NYvyYaqSvcQRSnlBBwRSvnqr5I5vTERBwwsVm/rnujSJyoYP+myRd8kB5UB+uyxVkR/rJYMb/7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.10";
        hash = "sha512-UcMs7QkbrdCCE83y3UXNyl8sHftlrjYXWpS01oDKkAXU5eHQGQ8QdwliYMd08CWMJNYl+KrhZ6JouLht03Kfcg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.10";
        hash = "sha512-2Y+hIitvGjHionOXNweRjikMHJP+QOhGWDnIxGP6wb1sapbPZa5UDW+MkZsysZ8aHswDzKmYgKIbzeIA5bnMHg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-YJcDRyLrbwJe1wWQBaxSekhc25lJE/a12LpAVEwS277i0X7nKBDwrdbqkAZMaN111cMMXnTjPz5rHRK6iPA96g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.10";
        hash = "sha512-FPeEQrCGtDGwumZ2tZXUBqM0fOVUTJy6JjXdYSd0cjkXkWWPm2vDPYumvccgzuSF2RqZ/xct9qOF4Y+FKaeKqQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.10";
        hash = "sha512-N1q/arfVktI+TQQrYDrMIiiFcmvgVvG6c16jYYaI3M9Ca3pSR8CVrtHYGpPNliDLlNMesFwmqlFq3oiFZ4Crgw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.10";
        hash = "sha512-MSaeWizOepQBNsHNgwkOH+jDAjLhuEVDxpqJSXaHsbcoYRwb2QGZWrIhhWPCPJtDxfMGaF9/tCeb2eJO/rYpkA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-5bndNosFdT6vueS0dA30cpcl3Lm8o+BkmXhAFmnr43xxYWThqpkPz+pCgZVs3GSaglXyRPr0QHfSvhXbLkOWTA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.10";
        hash = "sha512-dtl0t5l+FX3XcXBhZChlNCZlEKQtNA14/VDG54z6d74OOwpygN+IxVI/q5awpwnZU4hNsTo4FZWXFZFzkF5f9A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.10";
        hash = "sha512-srvSV4GOoME1JBtmxgenTv8gOyBGJohVrjvCfp3rAy8VZFFe30nt2fdCAcswisxWrqMYMxe1YtbhRo+Wc6Xydg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.10";
        hash = "sha512-h8NNNJt9ZdJziuRKYA/+HkOhjAABktWpUPbFB/80Xg4gGWvQhdnAgBaQgMaJ1wB7p4l2Ar3EnkRhrx/P7Q+ASg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-CBE1dJLOTApv3TfPanklJERgxEbd75d/xJhIrstGdQt6po8YVVVRNUK+4/TCdIRaBNkHb1HnoZ/VJCYDc8IrBA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.10";
        hash = "sha512-59O6WHQ0qD5Bcasqf4gSgdvQSZAHwzpMyl4q320J+NOw+wkt+C1A3PbdGpFQDXKTm4b30K/wwhgHWIxDeP8fnQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.10";
        hash = "sha512-UHzJKuK6hMq8YkwUFWv9VGQQJKxjlxmy5otAkPUzU7XAPljORlcawf2jX3ax5pfYBR9/npx47UyBGysL0lTw0g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.10";
        hash = "sha512-hWAGbrhPv0wl0cxtOgkRMQsmvxYd0W/K80ImV1nteJKSg9qZf+jaFvXOadTA4bp67pEt8k6Jf88CQObhFw8LHw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-7onIdFISoMLBVssn0VkktcccyDwhVj0zy4pPCbV6VsA3z1aDeL2uK7mjAnP7H3baZmhMp9Y82clpULg84M6ciA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.10";
        hash = "sha512-PnMUZ/8D1M2EQ/Y90ZYLBsloPYaFhsrTfCnXooDk9ncFO4fEQ5m4Wyr22Y6Fcd8wMaZ6qeTIvHrT8nxkqy45fw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.10";
        hash = "sha512-BiM7R6HEkg/0LopnCfkZ4gftoTJKy/CVbimDiAaOi65QQny10piKhYVBxuYIYgIeXgrMM0/yG0uJ+Oga4wFlWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.10";
        hash = "sha512-esRCulo1jzqjLsJIlyv6G5Vm2N1/4c73uHxXBwypsGQQv1mWiH662dhEWQYxFMzPvj16xbZFKFnzWH7GXg9nsQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-CHZo6vpuOUcFSxICauu0acyT5cNXULDhChXAjbWQ7HTYqQ0wwG2KrccbNgI3Z23P8WzInGOhcSANsmkQONuTAw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.10";
        hash = "sha512-CSu9MZsgF8JosvF4gcYcupqOhMPw9MQZVCC4o1rEVeNHd8xuBrNYLTHfG+fhM0/HHHXPG7FinGOfFzVeKMvJOA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.10";
        hash = "sha512-Vm2zCt45BN6M2kRj7XYiq7ZjGisRMo53+4uhp0hAepJIgg/r5layecEfu1H2USKT9BS36cID6fy1CDqtPoL9JA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.10";
        hash = "sha512-r6SDNsf07SZ9zBkmZ4nvc/Ad9hN3P12nuo62CKW6AK8gyEyLPfbzcNBob+4QWRBEMCF0ZqOqVQyEKsUiw6Ll7A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-jC9MjbCbm0PREfwQFCyPskKzBEKfQKNO2Mo3LW4csYOTGCRJq+UOTbgxDWJd0/nOhvYBmwqvXFayebZvbfJd0g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.10";
        hash = "sha512-AHcgn7jZreQG1h//VMxStIK841EV5redVIP8npSbiuePf+5xHHFiqPnY5KsHvsSxZqPx8WZS79Txjo/pRE+Z2A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.10";
        hash = "sha512-y1oG3/v+po2IyJr3uvqCaA8m0QSHTApY4riwzKjjlZNQFE3rsdg9Nt0K4KpoTw6pohokl8zR+LCPnCao2Zf36Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.10";
        hash = "sha512-NdHZ7L4Os4lHzlc3SQloTiI/AqHSoiZG2bN8i62dfbM+CXCrBtPG6ZeJN2HMGrCpkvuAQOo5svV7RP71PqtL4A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.10";
        hash = "sha512-uXVdcOr5womf6l2CUE+J489BgVUIUegZGQ0oMvd5wYA33AuznTmK+PBsEgqFpCmbi0pqbCiftvcg9LA8HOyt/w==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.10";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.10";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.10/aspnetcore-runtime-9.0.10-linux-arm.tar.gz";
        hash = "sha512-DrJyEIKTz1e3aAjWMzTphRd/CaaV0I+ugXdIy0iuxdisN+CNxsx9wIosoJDT8piG49/Hq/LsBxj9SCFYhxQsbg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.10/aspnetcore-runtime-9.0.10-linux-arm64.tar.gz";
        hash = "sha512-7yaWobgIAxLoevi/EzWXGkmgt9B0sKYnZHPljlRg7LVdGQhBPTTTJlxt1c/IwcYKsE/LUJyUCyDmHqWuSdBJJg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.10/aspnetcore-runtime-9.0.10-linux-x64.tar.gz";
        hash = "sha512-uhsYTzvBx9QjGGJA+jDkrNC4OS6MYbe1k7jRL4rMxl3M/NQSDZuewlw6J430+68yT/LPG405l6JEF+squy2AQw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.10/aspnetcore-runtime-9.0.10-linux-musl-arm.tar.gz";
        hash = "sha512-q2Jy7eY+qfSikE16ZdEBCpdJ/cTBozgRl+63reQDE4c5WbGSh9qnBLpRBko0QBEupnrrPbMyj1eZFz/WGt1cIA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.10/aspnetcore-runtime-9.0.10-linux-musl-arm64.tar.gz";
        hash = "sha512-tU5MHks/k76nrKe5SBGKAEikoDt+AP8eGfIBpXCH4Ozx5VDdBU3JyE/E15I/gEWtoDnyVzoivjaoR9zWv4psgg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.10/aspnetcore-runtime-9.0.10-linux-musl-x64.tar.gz";
        hash = "sha512-sptOMWM0mv9ZrZnax6B6O5qO6hUwYOVXP+LGh0+FaZQHI6HyLdcDVLIGK6jsBVhgs0Xdy49F8Qgrg6RdDECfdQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.10/aspnetcore-runtime-9.0.10-osx-arm64.tar.gz";
        hash = "sha512-Vqzoaf3qwKkzfSl0qEk9AEH0WtSsDc6gHBYsTYzrl3BpfGqCzgg321B3ZlbiOy5G758F/HscrVaq+O97LojsxA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.10/aspnetcore-runtime-9.0.10-osx-x64.tar.gz";
        hash = "sha512-W77nh80jQNKE1UgYEP6KGM5ohYx6i3fLbayL7Njc8j2CXOE9DFIw17nN4kIu+fJAxbjbJG9e5FFOWoQeVSWXcQ==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.10";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.10/dotnet-runtime-9.0.10-linux-arm.tar.gz";
        hash = "sha512-ieTvCRmRC4aMnHxH4pnJs0F0fs8fz8Xp38VPW1a61AqcrIPl9URkTRqNqhaY4td9T7Qg74F3R/hRAQPh8SJyMw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.10/dotnet-runtime-9.0.10-linux-arm64.tar.gz";
        hash = "sha512-ew2QitVOBIQKbOavzyGlIwnr2hCTEhimal4vY8Pf3o1dJn9QPi+oLi4raBmpIFJSXRQzQYbXfAh40C/H11S5aw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.10/dotnet-runtime-9.0.10-linux-x64.tar.gz";
        hash = "sha512-bOs13cb04sA5o4eeLxj+c/QnuSS4aLAwm/YffSNjbknVK1zbq12X+LTgh2mr886CHnrNgCIl74SIJqAWXGynwg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.10/dotnet-runtime-9.0.10-linux-musl-arm.tar.gz";
        hash = "sha512-cfWfV0HMlJ7RsMGDQeja5bLL1i/yVeyBgfk6y3dVSY7Oa5cW6OeUthpBEdUyZ9NzHSymoB/JFVHMNa2cVZaCFw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.10/dotnet-runtime-9.0.10-linux-musl-arm64.tar.gz";
        hash = "sha512-UeOls1JOw5S4hBwhJlr8xwc9bkYKPBxm7Yysh7nxdZ/qXbb0fETCsOFu5YB5C+iehnSz/xTdS82G1sZHUbH2hA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.10/dotnet-runtime-9.0.10-linux-musl-x64.tar.gz";
        hash = "sha512-bTZhDomqc7dGXMaEvlgjDG625E+UXoL9SHeU3KtlVumszYmjUabSpL63DWlXxpJLBj4evewIIqbRxMN+qigIZw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.10/dotnet-runtime-9.0.10-osx-arm64.tar.gz";
        hash = "sha512-zTNls2XAqCSP+8NLejaWmWnTMBMxxeTYb6OMjjVTaxWcWwyEy4u8aXS+iZiAa+vUx1VEbYF3+mEqxzA0fK3dGA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.10/dotnet-runtime-9.0.10-osx-x64.tar.gz";
        hash = "sha512-QxtbMnVNpR98VkXzC6GxmMtS2nwdT1dYGR7un8XJ3eXpKR7FxHSUpbMguIKwyLK64t1g3AlvnfZiiWsPIfEVuw==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.111";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.111/dotnet-sdk-9.0.111-linux-arm.tar.gz";
        hash = "sha512-/IaiIgIsWRhN5VTG/l3yCifS3W+6pjTWb8me5KXydH49HoMoTzdhqg1SkmHeUscZk7i7cvtu0sujliTwnjTp0Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.111/dotnet-sdk-9.0.111-linux-arm64.tar.gz";
        hash = "sha512-/4A5uvVy4o6OdPBiimxrL36J3uugLO6zyFGAHmxgvJAPkKwso3c+Kdij46lzUKq1JOvyn5HFvbsuwuEO+UXBkg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.111/dotnet-sdk-9.0.111-linux-x64.tar.gz";
        hash = "sha512-kngglXr9840rTNs8oNJM5x1ngh9Qp/cUE8OOYnuHdAxam7DiQEmL63q6U2vBy6wOfdQbMCXs+GQ8TuQOlz0pYw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.111/dotnet-sdk-9.0.111-linux-musl-arm.tar.gz";
        hash = "sha512-eUwJze9/itrIWjqOcACWzqA2PK6cKLQACQYZeJfnSBlqN03KnW/uJWfcO4JJCRXj0UqzWV/tQQduL1eZXPDkSg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.111/dotnet-sdk-9.0.111-linux-musl-arm64.tar.gz";
        hash = "sha512-n5Gx/KaRbRjzbITBRLO1AZ363f8gFv8K1N79LvohQ4BuO8oZNxfG5iAG9bpPEkr6nr5MLxH5VA994+uwbqPrKw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.111/dotnet-sdk-9.0.111-linux-musl-x64.tar.gz";
        hash = "sha512-+AmEq2w0Ipcd6fI1kvyR4wtxOQBu1P7IEaGTa7cKLeAjyv28oaz0gHi6gvwWgZefwUHPCbft2zMx8tF23hTm5g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.111/dotnet-sdk-9.0.111-osx-arm64.tar.gz";
        hash = "sha512-WW3TP1oLkR6uN7u3isSd7CE0IG4VhhPJs+NDE6LuG9Zng1jqX8VOl4lucNJGRqc8TRrqTA2BT/494IwZtdsO2w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.111/dotnet-sdk-9.0.111-osx-x64.tar.gz";
        hash = "sha512-Vuo+OdD89Kv0g+f9kZhbhjluKmISHq2Za4uQlHZMqI1a0gV6k8pUyzPLUDoHB0gLknJ9rNSaBN7JZVhOn7cyRA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
