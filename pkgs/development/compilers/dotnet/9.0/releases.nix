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
      version = "9.0.15";
      hash = "sha512-Dmy/JRKUAyRj0X1Lqk4vUtY2HjNbsCsBJj0mwO+jDw21tjHZsZNk7niTDR5Tv0liKiyg3uCHlW8sTljpUWVsVQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.15";
      hash = "sha512-sriH1YdVut7cd3LzKKd0oYqI1UCKtj1hVzADsn2h1eQo2Dbc/kHVPGkA1iken7nSlq44dXqf3NG6kg0yZsCB9A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.15";
      hash = "sha512-PEo0LjgmwpvPD66QwMaIsUIyNUI2fupxTTPupW5V0nrHqmzpffucIWDVDosjgmU0GpGa6HGwlW75FiCt1zF2aQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.15";
      hash = "sha512-KlB52JP28chmlmurlUGPEmrW/SYKtE8kKJK6F3fDybVdQG4jRoV/ojgTc67iKowP3oHOx2oAEkW0ogqRLyJQ8g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.15";
      hash = "sha512-0ITcaDR4iWo44bInmEy0a3rUmyEaDfP50h3a8y3ZTWAy87IQo6PhOj543ekhxVRbIHZzfUaqWThy0n5jrZG76w==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.15";
        hash = "sha512-CccM7BKzWJhW8gcnMpq8DeC2dhSmbnfCiixQ4wI8mn48hKNazhYCYKNws5Z3mcrKDwR2UBUwcWHVEqFSjWj4wQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.15";
        hash = "sha512-78j6OO1RyiRcFGaioklJQ9u/q0VBMIQDjrf1rkx6et8TYQDPLi6baokGktWzMNHh1sXLdO8Vsn1kfysNoobpVg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-kuIy1bHzIdYe6pta/LPMpH5hni4btriPViGWeXG3oqr0hmpLNbjESbGW8h285W7XqXNFIxtt62fiAPonAN7QjA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.15";
        hash = "sha512-UOydeXToh8qXtenjBkUVxMn7+4bnWLUrPfzMPpHdlinkzbKNEKw9XTdncr6o5KLTKnkRLvtrCND0JXdaSV4JJg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-HGSeAhDQn5rMeJZB+lbacgE1qo0oYyt+nF2ND6PBcpiIK3RZs57VI30kbhLXN3HRlzqlWwmJquDRSKO/BbHbDQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.15";
        hash = "sha512-bUamlaf15zuhTSHOzlP3jFuUZ7/pqYhbXz4k/deDXsjuxpto/97uhkB5ayWnh1QR7t/phwek16Mjj5TgpPPRWQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.15";
        hash = "sha512-qqLyfUZm3RSMMvshkMChPrhwpCzINWwfwPz9sF/Staed2oCO2Ky6+EnE17yGNeM+KVJ7ud6crqcqRZXtglfL6g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-/2zp6fnz0dl0KojSH4xSvR0WpGkzAy5Yh3Y4N4iWjxw22960EuHuVscCYVBriBmVS1kCrjJzIZvBGIGJyqTe8Q==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.15";
        hash = "sha512-/vsIVhl4wptyjmmynZ5CRbiJU61Eck0jK/Er4NCiIuxz5YD1GczjiNoYkXVip3Nt7FcAoT7jrlDeyJHONl2LCg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-WR9+GKDUROHe5FVwx1aG6sPIlEzeQs8o/QlPaoDxmlxS0M8bvVQivr/DaD8JWFymryUVakOYP0i6CgsrGsJa7Q==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.15";
        hash = "sha512-HwNqX2qYcymE22qFpp/R+1EYMw94qbVVJl6WL19TcdLmWDzZs0acP/O+jGQX9+LSZ1vY+LEfYUFIu51W1xu/Bg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-ouERhZLL3tyv9PCSa1Ffi3CFRFusaXlikyBev7wv7mcYSA+xdlVaWk85n10reyRXN2tKJIFRS6k10aOKWUbnFA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.15";
        hash = "sha512-3fBu+ZuxeT6gOiLKm2YJWzbuclGH2089ePrvKQxxb7hvqN8mMO+G3lfMGqA9v8aLE2GNWp+MDuEiyu+m5qdhOg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-2JWrZHSBp/756CizUZrj9IZw0Uznh7JzUNnDfHYWp66dTmFcgILSW0IaT0qX9sR0cM3Zczsbxa2+vRlW21Ff/g==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.15";
        hash = "sha512-opDL9XZIXynZJOsVm5Lwy2GM0BSBaviPNpdYR3FBsWjwmzmKMyZ179gxZtvCN8oAiYtOeX68MYo08/zrg5sPCQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-76ujuNNSY/OWDymu07qIzCbg50N2N/OW+TxIJhprGRkm+H0r2e43RqPu1Fu0inJpCPURAW0EvM4h9Ymq1owalg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.15";
        hash = "sha512-zzfQ25bkS57/L57cfWMpzZRoog4Mnwl8zr/azNrmy+4xgLaTEyYbRrOejpX++YV7AjRvRZx/q10YQthx67ltkA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-UFLEKhYlC+aWsyC5NdDAQF8okWzhvY8RUVh/KHI4m80KR3R4Bpkf2wKJxdZFZLsJZzB5dq+K0k+lBcFHSvc0AQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.15";
        hash = "sha512-4ZU801ACFv01JnQmsT4zLz1EyQ+AC6o6sh/wkfOwW+XsxDL6OyAvIcEOLgeW0C6Xty4b+/t09Kp4+DK6nNAz4Q==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.15";
        hash = "sha512-aPQygwswbMKyGAofduIWKsgV7oIDoyKYhgcOtn3fXH+4gL2Whzc8BAgTYp2k9WTgOGn0oelC6fqRshEidl3ffA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.15";
        hash = "sha512-YzvaK5mAVYItfTeDShMrBEOJbcGnGM6KHFB47r7y8rGugH9u0WIX1IeAKDJzZIc9DMuRn4XWu3c/zppBjoaz+w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.15";
        hash = "sha512-1kNFIJH66+oaW7JnkBu6lVchgedk8DJ+Lqo1kiiSL08QXJ0M7GDkUlMFv+21nyPEdAph7CCrsTEgiYOB/0jCHA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-kkmn21UH6tYGmelepxMNOzs0rJofMNkkIHzIPfzTnVRfBXuVBfFQQG+SL+9YeGP/ExbIvPqLoTtSIfRbpTW99g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.15";
        hash = "sha512-fWtSGeIixxjpsLj1TheWKnGGVLC2VLRuHCFV2YRP1smNWAz+pjcJGkw0CnHG4Due7kEJGe8aDBrBbroNDLYsLg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.15";
        hash = "sha512-/umhnX88rosnfUCEciGzG6MMNWFGWgCvBv9NmJknPTR3Xc1oGGMB4v7uBrsOY6cpYb8up7+jVxn+uzOwBX2/nA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.15";
        hash = "sha512-vZiZin69Jx7+GwxDvxtsZBiqd3FVX/SCXiRsJzGwKdRoJBUw6XGNPq+EngCdZA9+5leoGvGuvXGkvMNG1l3RCQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-JH1o5YNq0ZKLMHQbLg+l4TJkqKa6zQKO65vKLK5opantR2eTfjPJAO/zFRd3Ihgk9gWJqjbuKVNhFoRgsZ35dQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.15";
        hash = "sha512-piCf0clvjiWZR5rnFT1w/Lt8GQNu45CL+mYCOvVjtryfKEK2CO2MzwT6bh34sJBVdnrT6SJgxjvBkE0gDPNxTw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.15";
        hash = "sha512-dbZyvc5Zty4HCNrJViz6TXf0KaZQBKOVB7F90t+xyIX83KCeJGyyofGrraL+LtdYzdkTWX7cU5bo2hR3j4qx7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.15";
        hash = "sha512-HFR98+ws9Ag7mNcoJY0k9EsczEKJMiykvIp2fFH3xR54tc2oe3KhU43+T/83R/o2XWUeN9UpXdKnrG+cn60FKQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-83MzBWutQt9TlJvlC5IW5vWj4B1GAL5drxC3kahbEj3Xvax2aZDQ6DWa1x93Yy0GqhBh5jdjh06jy6gGbaUzBA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.15";
        hash = "sha512-fOvZ3EzANpOKnsW4mtr4O1vEx9WB9SYnuhaAp+hMeU0HvtUbs8ttcK3g9vkMQibThlJkIGaCMRvyeeucmtQg8Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.15";
        hash = "sha512-lXHR4ONEXvqQ+r7jUJGyl64GQe+h+RjTda6iwJkOkR6EP/YfM7jEQzF1pfTRpdDS5xF73GuMiSAlpPI7Df4Ixw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.15";
        hash = "sha512-RSxv6GAFy9y+cz6Jtxj6K1V9lS5Np7hK7FvVj+sGGMAhMrNMfdLkRH9VBzNzW4IPWeYyK1t/44pJmZCBmYISzQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-Z2bLIv/JDc/70nWwSGi1M1IwRp+R4IMJ2pUerOo1l3wT1YfccBiQd3L5Egz58Z7/yQfBfF9/F2zTRelIXo6ITA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.15";
        hash = "sha512-vgfVrPxhPhy4tXd3CwcjrGhfaw8F3fyuM0E1d2tOyRpH4Blbud9D/qPsMX6JaulQEwiWD1aOdiJSRL1ToIzDCg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.15";
        hash = "sha512-75SjYjMimv5xRnhycyATGROIPcsuIIQakw1vZ8YZQhxq1GxXdO4YScKNIbcOhgIN3yxq25My9abicrsJOOPnVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.15";
        hash = "sha512-gGSSX/uuYA6QQJ7t3oWTSKkV4VRxs9SItGNrRXOZXl9zSIjvAVVGX1NAZQ3Oj79wNuAPuuNDgI6xnhalnm2cwA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-KzRN5p21IBbyIp0INV7bIEHa6W68h6hpk45j2cw6miZBqvB/hZgcOYzsCvutQ3nGNHdvBtFSBpd1DFjfqeALAQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.15";
        hash = "sha512-GDn/Sq12ac66w+XsLdjwJLz8BHKC8xlIfeXwdXMDuKNfi9fmNPIpU3eRZ495tsubZ6D290JldHREyALq/hks4g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.15";
        hash = "sha512-mI1GsZsm2yx8CQmRE6LXxGQI4ee7t7TaDk03h2ds53x7OlINq2O4vIRmeCFnToF2pYcWMoUnZE0D/NxqbaoBvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.15";
        hash = "sha512-rqdBPvr1OKgQPEeVwasgDxRPT7GFfJZN5IdTWoInnoTLmSaM3eG++bGVF/l6Pyq8IvlRfOTS/X7LNNAUTs1keg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-oC9IUqxwAmiyGC3+DPVZb4VkoA1yucTv3qiWYLD6ozPMK3LB9fVgh3R4y5+yqhylvNkIR96eLZSjfds4HUmjBQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.15";
        hash = "sha512-f1xq/KbX5Ba1ujCjkZe5EnkSCnRTgEJEKVQTDH4ZUkRL2A62SqsD/rF5u+JcLVUSgIAnZUPBYIeAFeIRJyCQ8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.15";
        hash = "sha512-uBzy8zF/rU/nOTeCrrkBnFKsSw7WNrJOQYKyL4+dayopxsFo/gkC3n3/z5+09gPyGFMOetoTFW0NNk6KmasOnQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.15";
        hash = "sha512-6g4QI9yu1Tb4bDiXY3bkIlIidNo6Mp69Of21zFSSUy0dRYDT2kuNSjDgkr87sAQ0exqFYWRwZf+oBfNMj3gkcg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-JiNPcR8WnIosO1Bmi/GzhrOocPz3g/gw/hu3JT9KQA65XMZLSwQsR1zBh/0A9hAd93cU7rTPXL42/OGE3J1aaA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.15";
        hash = "sha512-iaLUHu7zxURFwxJY1QgJCtOJaRVQ3kE5iIP9e9+FEX6Eum9TQpz+FISQrKlLsgKZIloC/QLL+JeVOnqRAYelLA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.15";
        hash = "sha512-Wf9f0T3uPBTN0B1PY+RRzSb5zkwtPuhm9ORJ7xT6RcSwrasCDhOjUjEEfBHTLob1uaNu7dduUfpwJEwgLTvSfg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.15";
        hash = "sha512-by2spvXuAVK7hMzwRlrzDEQp6u/xsGk1pat1Bg/ZSFeNsGdOUDV2M4JDGp5r35YVVeaEkqwu45D5zeoQnjTP+A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-Jp0p9a9BZTCNPEb+2CK+d5YP7yKwZbU3KH24s47iOgoBgH4OtATLxLUw8IeHR4UWnNluTQaEI8XW74OWRDQTYw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.15";
        hash = "sha512-cJkhZSB1+r+CBZvtIuNIaoyzSj8NuDMZEbocbvdKWPOdWoXi00MXS+5FNKEIPe5dunczxzzaiZSIkL3mydylXw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.15";
        hash = "sha512-uup/ySeaEELPXsZ1qhxWrRinVyNoCMf5uL/aWZXUIObO16bXFPLkVqSWpDxWc+i4sgJ5hFDsYnfM679hAQjs4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.15";
        hash = "sha512-E4Ok7I9wIFD1jiXBUWJNDejcwa8dXVygO19EaMdJokJxGKfcWFREOpaV9ms2YUInvJTJ7VMWvKZf6GnfVE5ijA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-QbpAZeuiKOLQuXEFySf6DhA/iThelyKFv+CWt4s4Rp+8tBVYbCeHsqgXWLeb5d1G1pIEt1dJWc32+EkJXr16Ng==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.15";
        hash = "sha512-/Cahe2uC75WZ/vtFlKur7ycPo1Zmrz5r8t74xpQbSNsGStWHQBK9sEnLwV3SWwljlcH6a/u+oFvXCp6IXzglCQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.15";
        hash = "sha512-Uacs2GBcRDhjJr/NtTfEwEbLitGatQuAXiN2m9MCMXjJhIyjD2iQZQ5jyiLhP3qPUqAtT1dABRdMLQdZDq3/1Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.15";
        hash = "sha512-sEn709wuugh89XD2xuoqYRPsNLlZcMl06pUFiIk77xXqJV+j9b24pUuFyABMIznvpP4PrPjiIol5boDWOjYapg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-p/qjf4sBksZPwoEm0E+/PRq9r1csGOmFYSDYp4dUErEonPaa8bwh/JnFuKTeYEvSaQiUyQv55wAplJDFOsck+g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.15";
        hash = "sha512-5IwDAasQUJrSpfLJ0moh2DPhmPmZxms1BqXZaV4cOzLHNhUFG371cPjkWkZzZAyZ3HllV5eFXeVZm5seQdkpUg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.15";
        hash = "sha512-Tz/3og4/uHOFFt5U4veHS/Vhq9jJvQAkVYCmBYqjqSf3cYDxPbmIAb5B2anG/MQuB3dlyk4Pk9GXJeqyprJP6g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.15";
        hash = "sha512-lMYQuXKn7x2Rz0d7QWEZvxuwUCD8u1Z2L8VLLsFPTACooPzabiazpWIGjXmWRzY9odOcs9IvqvbvQAry5ulIqQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.15";
        hash = "sha512-tgtryDXEtgcm3i8n8TEl3f4M2FuwvkOJS6zIBdbAgFpn5VsvMMTJOcXls9VoIEculvXJCtrnJfwAa1VjVFM6ag==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.15";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.15";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-linux-arm.tar.gz";
        hash = "sha512-2MdnGx9Hc4a84bGBZqKVVEsWIefdwCEsbYUh1HuupZ/jnyc1WqgkJtXdr8STYUlSCvqlHaKJ16MmQRc1kvT85A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-linux-arm64.tar.gz";
        hash = "sha512-crn0sGSeWjuHRZfBtQ27skaDHpM0VbvjTDxT/90wFuyn1CCQxteFu52ueLnzTTd1ffK0MPYwnYEcCN9oOc4Azw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-linux-x64.tar.gz";
        hash = "sha512-hdR0swP7jxhnEl2aoew521r/8XmxZSh+Rf14t+xR1BTlk3hxvaWUi451Cv6cIgr+YTjrpxCAkL+6Hl2tk9OcTg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-linux-musl-arm.tar.gz";
        hash = "sha512-jIsdggwg9L4DJecnnMI0Ocpu5CaV/RcwxxZPLFQNN5kQOthDlN23DmRN0HhVuZVUdPAcIQkL822b7/bYV6wURw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-linux-musl-arm64.tar.gz";
        hash = "sha512-cI/+PvvW9CyaohLiVvdPNoAFHzC9EqQxFcq1Ew5lWkI5v5tX0liVH6Q6Bu7uTwOduD7P74cTJ1mXedj4aAackw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-linux-musl-x64.tar.gz";
        hash = "sha512-9+P1+EkzPr7UE7QjrsvDCj1oRX/US55EFhi2ey4i2AfDgEbw68Ih46PsydM7rDBfpMvXw9usDCiX9cJSsAoUqw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-osx-arm64.tar.gz";
        hash = "sha512-xEHHwAQpEHaMhyCXP6lGc7SAOqXABNp0W+QYBeT42PSYu7ddbGC+7QuFHaGJsRJBqUvd//NE5WsYMaI4an4hMg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-osx-x64.tar.gz";
        hash = "sha512-I5uYew1gididOkB1mlFfnD3YAYklekxowKIiKFHcvDRC5o2w3yFneX2EUmk+UeqRBSmImLfQvIIGmxoyscyArw==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.15";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-linux-arm.tar.gz";
        hash = "sha512-mBPkfVY+eu/Dlhi/ammEeF+0Hjm2x803u8B3DsdoKxnkqhNYfCcqCt2Zbz2lgH3BDv5gwpKhjONRKs4Fy5qt5Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-linux-arm64.tar.gz";
        hash = "sha512-hMDs9fd2WSjMhv6UeWNCdvFgk7nOsgHioX99/lVVXZCVgSBOY0d1lGjEl6zQs/uFd5fhRKLn8brFa7/qTVrIyQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-linux-x64.tar.gz";
        hash = "sha512-5lsJk1eeCvpwnNwo9vWuElJDfCy9L9zEtDboW7vOcAID/xVWPimF9SjxdZxDhlypQhcTnTbWpi4bUpa9mi5AUw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-linux-musl-arm.tar.gz";
        hash = "sha512-9jOPmuxkwREvjr4eggYcQOmUCZ0oxCfGPmyp5qWAbedQJk73McYja6TzzfXX1E5b9HgnAbD5xs/x0HnDpG1v9Q==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-linux-musl-arm64.tar.gz";
        hash = "sha512-zDBJ5Ynd4gppWr18QIu6Ch/8tcnWsuFR6P4OHKxd017SdL4aDFX6dGo7cJ4NtnTa4hzf7ccVaGnlVnrFgyBdfQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-linux-musl-x64.tar.gz";
        hash = "sha512-BWmY0UID9eQPrU7ZF3rStM27zSb2ALcgAm98RUYL+MtHLACQPOcFwR0wPoGgPvSdut6ROI5Ehjo+rQ8fUAuxbQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-osx-arm64.tar.gz";
        hash = "sha512-KLa2tkJvx2KvgSIv/pXQ82uQdQBwsN8b+yXlSKnQsEwGqpcuSF8nra8Bo0hXoy5zYCSUv8L0Hk1sIIld0lKrug==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-osx-x64.tar.gz";
        hash = "sha512-XYvUzNBpo+nLJ+0cRyrfaGsG0ekgFY8ovbLSjgM1PM37lzcEoa6Aege4DooM1yRUmpqtT3p4xqgGeoLPhwWhQg==";
      };
    };
  };

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.313";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.313/dotnet-sdk-9.0.313-linux-arm.tar.gz";
        hash = "sha512-Jn1osJQ/k/y6x7Bk2Tox77NbDEvsRyqagFreU3cIrwHwULLCVQb27M5R/W5V6aH9ePe70PPqGdezyqwWYGIMeQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.313/dotnet-sdk-9.0.313-linux-arm64.tar.gz";
        hash = "sha512-AnjIa8ycnaKivg9D3TSozeLUsfVBrRAcMNtE1EU2OI+mQcV6B6esgpt9QDESdgsXLcYIiA8yFCCIJ7syBcAaYA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.313/dotnet-sdk-9.0.313-linux-x64.tar.gz";
        hash = "sha512-yy8JzD5EvhUuj3q9/rGAQPbeXYGVvHI/WESDd1rxab+l8XwDzgy2T6U7zH0p63gQaEo/pM9rIo+lKtEyv4m/Yg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.313/dotnet-sdk-9.0.313-linux-musl-arm.tar.gz";
        hash = "sha512-kXdY4NGiCMQG9XbumYdb39NaaoRZyYr47yzVMBzkP+fSlb+T0YOU+KXz8dryo+h9ApU3Cva1QWoi/Zqk4G2xCA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.313/dotnet-sdk-9.0.313-linux-musl-arm64.tar.gz";
        hash = "sha512-ge0QLlXYlU0HANbuaUG9CSlugeHwTDtC7ICJQy2gJqjhav6hMND1C38YL6jfgrc4ntTJI1uR5fE55kNwoXFZkA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.313/dotnet-sdk-9.0.313-linux-musl-x64.tar.gz";
        hash = "sha512-ZgMXDBKHNBpkPQaDm5SGweH2/gUnoJqo81hS5jXYk5aK8tpfQFAb2ecNz8qNbhLUoKxCmuiRaCsUrsUlTXGqLg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.313/dotnet-sdk-9.0.313-osx-arm64.tar.gz";
        hash = "sha512-uF1i2CZq/0ZRfuJsKuEKe/VSWhxVEsdlkZoKK0pwf5Hpy7KO80B6DsOKKDf5PvXPV2KCzRxDSCnKtTe+pkQy4Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.313/dotnet-sdk-9.0.313-osx-x64.tar.gz";
        hash = "sha512-p2dCqufzdO9JFHPg6P6LMWEVoXxhTsvQJo1BnF+EzsQeA+CZ7td3WC0aEfRW9+CmQBw5TYG5KmyTqXMt9u7Ing==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.116";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-linux-arm.tar.gz";
        hash = "sha512-r1e+RNozPEhRhAj6Ojcvn6HyxxygANdLOnjS7dJszo05IpCvJSolVTBg/yjzLGbBKDEFLCQEIv19l+HNvUgbPQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-linux-arm64.tar.gz";
        hash = "sha512-BdA9L6RCnwtIO1+J1FVLjdWBd0lQBVJFWy26Cz+0ICeZrPZJa02tZtJxq9PRjD+MLw1yHCnGN042ou2zaEKZaA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-linux-x64.tar.gz";
        hash = "sha512-pBBcDHcZ8ymeqCKZlnyGauZVXgKWlp7dll7NyL3403dR0f5usw5FfOFxHmljuXhkOIHiN6W2/ZlQvCALO0892g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-linux-musl-arm.tar.gz";
        hash = "sha512-swKUn6TDESwXoxaAaCFpqnGxzp86MVDOiertCGZ8XXru9os3ConfjIAY6vzGkU+fqhgVRH8cbBZrkvH+6gXwjQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-linux-musl-arm64.tar.gz";
        hash = "sha512-nijOyosqvl874rXwkSwIg9P6JUjl9zPECimBo1DLJ+aDuIWjfM4VnCz2Y9Zt53xocad8AbHXUpL/kagJY46/Vg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-linux-musl-x64.tar.gz";
        hash = "sha512-iT6QjPlFIESRLGObt1oCrxFjsCs6K3yxprtAgZoQEjyx+glOqQ4d09OAcgW8IvPP+kFL14bTAvH/UI5XTZniYA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-osx-arm64.tar.gz";
        hash = "sha512-3itAGFEqEamTQmXwawAWOXpXBDTq6rPphZgCxn9SZi8bhohSS4X0S83uIhk1J/ECBb2XOlj1GgEuXEqEpOLm/Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-osx-x64.tar.gz";
        hash = "sha512-6tfZS+xXXbYiGA2pMBdWerhYuWd+93sLvKSHhkeI+yu0XVNMNN63ChRHZDD5Pm4kAZeux0zUMQw6JQFUpgAMDg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_3xx;
}
