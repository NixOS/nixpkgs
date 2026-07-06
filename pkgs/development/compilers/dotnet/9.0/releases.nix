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
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.16";
      hash = "sha512-Y8IIsboz7NqBFsvqjMFMbREoCCfwlEWNsMnK1B8VNzUafsj4sxx9EX4yplpOQ/xLhd8GOXnrsyPTnBD/MdE56g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.16";
      hash = "sha512-UbHl1yF+pMazreAg1qnrEdQGeUDAqWlAuvvGs3VRC5X4L2DJ5B2Wi91NA4by7CJapaavW13QkjnS7eaymxzvNg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.16";
      hash = "sha512-HPfT0MFKyPRZO6+otYcF+sd1l64pa13v4wWPavH7mFqo5z4LjaMVFZy3RmZ4HIFB53wvsi73iKepsxy/u9pfkA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.16";
      hash = "sha512-gKHvpQ1RnHbmHS98zF8tWzkE9wl37XKcFzWZ6EzCppgGMgLw1YlzKDNWbMplKZ+jtXFMjpbcvLgAhF5vdL/dUg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.16";
      hash = "sha512-g6qC+SsAm4ne7MNM3FnE7UJhfnYfPZCnuiQ9hdfqroA8p0hbtTTfrnXfotKuB1dorcFdHxzxmF/y7B6/332lBA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.16";
        hash = "sha512-XsC+P6MC5N+RXJZy6aEmzIprYTgaOS7ZM+HfbC32olK9bFWzIlkt7mjFJIy0HL96S1UCudZA5Q3SzV0jEi4ecg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.16";
        hash = "sha512-l/TH0hGFWxQKbqOTtAWcS/eoB2J3o9feUElDx0QuePAI3sQzdYiG0Pcpnxi7gPvdVGZ3XXm1ymapRQFDlqiKpA==";
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
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-pIWCDQKACuUR+AV2WlRWiQBqWdNag0IW9s00Ov3pjzeaxBRz/VUL0eJbq3QNsH1ATkwgeKju6PbKCnSZWpDG0g==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.16";
        hash = "sha512-f2LKNUPQN5GCtw5JQXFrm7GktM6TAJDshVHJRIt3+dRuRMNhuMnjKDAysJIbh3GLwKaQQkhfGfFlOzXTIQKjqA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.16";
        hash = "sha512-Q8zP/Tm3JPa2rh2iyPduGuBZ6zywTDLhyTLX5o2eH+tLtlh2CPa4o97XRrDLlFhs+2T9mUBTMQqBujkybFqVCg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-Dq95JlmgjlsyxqId2kM2COFTHAqTMXMiNn3NzxKfNi3ChxtOdjlfe8pt4Ah7yNDF5cdf7EM9/tVHFw3xiDacbw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.16";
        hash = "sha512-jbhCQM+Oyc5ZB5xjQh6ZLU+NbpiDYk5J23np4zhNHLFOJFpzNtaD391tRbD1F3vqSL3bkDY051rcP+ol5V/h1A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-YnkhuwDOWgJgeFtZU6rBAWv1Bh3TWJHhxSPxeIC9QaHHKnYeJ2ET/3fsd7bNzyVcNu4MTYHqSrDB+Z+hRx7dcA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.16";
        hash = "sha512-qA/7jKoGf5liZJX/8L4JPswADax2AzWmCGhffJUQLTYsoxGldFCNLEwueMUwUEUDT78e4snrW556sCBHfFaBEg==";
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
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-HyIg3hOnPf43b/0berINQBgszML4eW5AYsjlRUl6IdAu5JPA9mttssdExgi3uAF/5RVyZeiFO2aQ1vlJO0/2fg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.16";
        hash = "sha512-PbMqeD8tC0MOkIfb0C613y6NNlCbJz8DU12vY6sua0FmIqWslTJrkNY7xwcdiolQPH7gAK9HO9U7dHHBrWP3AQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-/NQtRnyijfihkcdnjsa2WWcYbdILutZMw3pL3B2w78MbJeHv1g7QlEVEKgbKh48B7rloPgYycQPPB4wCFoDUuQ==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.16";
        hash = "sha512-b9cJJ8l6HP1kjGDn10yc0n9gEoqMkYxWr4VR446+chITZBOXIPrr/zPbWJs3CBkX9+u5gybc9kgYhpS2xRgPyw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.16";
        hash = "sha512-t22HEt4KLnQMoOsQhqpgMI29OPMKFnyW2U3TSKYYQXIBeNd9WDo/yAayuZ1cfuQogOkCeslE8gcj5njzYQF2pQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.16";
        hash = "sha512-4fAuO7jLgqY5YSjCIoM7uB3m7wglotjFgipR+MCaBP5hL86xOMzSJwfpec/GNSEs2+hsXRzpkazhjT2Z+x08sQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.16";
        hash = "sha512-IH5P7aypdZJvmCpKsiOxcQqDb4Q7hWA4aXD/TIOBVCFM+N6oiB55x7yEBQxsfH9f749QNvtRoAGlTEeu2m8nbw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.16";
        hash = "sha512-e7XYIOYCAZ20hswboW/vy0zE/HUaOajRF0gBd7NtQk7qc8ALG0i4HNsNJdVFn82GqwgvKXCTX5+ibvIvcU5b9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.16";
        hash = "sha512-PfV2CoSekXSB2jc008X5dXjyCVyPwfIoBGGiLZXrV5c23W8L/IAOxBkjLEHeLQs5FlP8jM83qTGlnwR9oFQTSA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-Q5eIHCeKboG3s/fZdpnnSrD7FSATLnYZfrCQB67sy1MTS2pg0A0GIwkgf8EvXW4C7cnfN78BJ6R0lWn0GejF+A==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.16";
        hash = "sha512-d7agtf78EsZNcxLvbOh2n28diFwTL1VCCAqZGBE5PXkbbpsygJQRMLHSAH/fOTrvhfgyI3vFPLtvS08hS1FkXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.16";
        hash = "sha512-UHB3sPuk50tn4Wo/aW15CcKmhoXAG7IHV5gn7BI2ltsLMJbXfgg6uVKeqvEWPEO4PvO7GonLn6NT+9SdFthp+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.16";
        hash = "sha512-ifv4wiafNTemDz1XSvZQuVVsNJ8m9YiYLEjKOjHVBEqIYt9//I/4IHxTCosm2KsWuXTyEyvMX8n3BKhSlqSH4Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-Mf6KlNpsZlQu9lgSndZke0M4YDj2VrLE6zgRoYvCYn30d1lpVI/FzIBw3vK/iJh/XX3h4QB/SODjuvxoOazBgg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.16";
        hash = "sha512-pWIHo7rd773ekgHa57Ef2u+5axd0tB1p6xlnZaVW0yu23KBxK/MnNN+3AA2+iqWHvg0O/aOfqBgXYFeoU9JFwQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.16";
        hash = "sha512-IZ8zkYRRTdVC4vrAuWZYCt8ugQAXh5O1o5B0B9DfBfmXJJbqfIy9VYTWN96E80gV8vHE0K1c8lN3fus7CmxDZw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.16";
        hash = "sha512-oUaAC24zXXYfIRwGfjGPQ5/l/ZOdY0GL0+8SaSgM5B7ajh18mWr4OwGtPhlh8LkKwM347VKovEoKRDgEgpsFkQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-oBYJzoveXZtUjr+oi6CCkzqJ7qfU9CVN4tf/F01iz2tCOC+QaMHm4R6z6FjCtEV5rB2+pfDaPvTqj47m81fxzg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.16";
        hash = "sha512-GnjH8mT/zeuHDDCFcp4Bs74vov+MqzGhEEnqi5au0v7VGTMhYD08w3hhU3TdzvhDUTQfURfok7ggtbzOhXx/7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.16";
        hash = "sha512-sBgU282QgnkHYQx9AeLc11w5nHR68eq96U2w2NtjHcz4H31AUji/GD3Oe1Yj/+tv6MB8tzqjLycZM+5YYPVggA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.16";
        hash = "sha512-YItidxBasuspDd3iwhjN6USIQVYxhMKCrIOJa5/ccyulm8iiIEt81TH9Ya8l8h8qVcjkloPY1c4vL8ZGuY7jOg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-18e1/YPUBMCtdio3KQ7CedGVMF6Q03b2H+ez0EoTpqAfmU7WcF+ZBTkq6Q5bziCkZAocw+SIjm+4y+mjc7BqDQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.16";
        hash = "sha512-wWOBmVqkQlLROidQb02E0W119YBQ1FGwv8kGlSoBw0EV/RXAHlnISfsBrfW+Cw5OSOz3VL+OQvlbPjtJ6ASyUw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.16";
        hash = "sha512-MvfQbsXx70ZozLmCjUsCQuVi+FKTnrgTa4bTu5hqUjzEVtLvc/DuTxbm3/UGf5jNHVjh8TVUwyxHbplvbF2urA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.16";
        hash = "sha512-l74HfyXD1j3dfpBloXc1vNDzaLOrZfoAVwGLV09OI/wiYi7sXOjyFiqOmKA+23CXzZHAeP45fhDy7OWvEn001g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-MnWc5uCQURhVhH5LaWZClUZtYgz7F2CC/J/xg13AtSJEHbxjt7TBGZaWY+PN5jeq+Id7t2JRVyCkfCrkrKJGRQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.16";
        hash = "sha512-bJXaLZG70XO7q7TSJmidLIk0DJ1t1Y/ImPDUjYXXEb9yhh6BRZZeO9mfhZl+w6rjeakJODS7AD9mezRobDGxRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.16";
        hash = "sha512-HSVQLlkJdNvH2qpyc+eUh80gd6XPOP45AebQa5+v0PsuM729R27X4lKOdJ9Q4b8eU/dw+D9BiBafCDJMQR2qzg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.16";
        hash = "sha512-M09CMZ1MafQl0l4/oq33PHbLsY64N+Jzoy8AvtYYxHmIyjc7sKJzluSPwla4JhNGo3kuV4wGr4iKjJB7ysvReg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-fkcHcJOrF2ykwdguXkItLgeae8q93CdMz1WCoLGYnqj8EXSp9y/b1J6qwkyC1fz6GdBvsC6ZeLzLmTFdtlmVPA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.16";
        hash = "sha512-5kvqOZkWpE19apTQ2TOvnHkxx1lO5LDJMsKGiNdG+sCo+3jMSXd5nuaIH54XHORPN76a6Thq38UrRkhEA5qQgA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.16";
        hash = "sha512-DIuYx2mKPr3itX+JNa/N/GLdYzrZAEj7KsvPcmgiqMis7dIya9sesrAS8ANlbWjhPQjlIvvJXFO4r0kJdz+TsQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.16";
        hash = "sha512-EMfad0WhkbIL33XTMpevCl0zoIHjHqcA1zb8cuoUGg3JiLe351nMVfvAPCSG8bVD2X7SXP9R7YhKNoY9Dnx+lQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-FmF7S/I9DP/z6DnA9Ov71f/ijuLndfM2bLYlr+Pv7S0QkYXcEd2W4owWSM8ShcCpCabvLDfqr8lBvZ6MRP0tag==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.16";
        hash = "sha512-Ip0Z469HQcuY0XULqc86HXuUFdk9bxUK/m+1zlWiq8Ar01JlNV7Wcvlv9stEnUMwiiiQZu46p0CW0rJgbgMveQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.16";
        hash = "sha512-i7+aYueRyppzBk/993U+RpEnJ+uU6QSFUsebSXPXK+IHQbGVQVt60dqWgNIzSMfaPwZCqIUhXvUnboDjO9e8ow==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.16";
        hash = "sha512-7qgycW7MWpOF3sp8xVA7REnggj/xQnDkdy4igkUnyL/UFR/wuH4M92ET0tPBBIZNALALGW735PlDMP+0ZXqrFg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-GaYVx8fjgbnpdj7nBV2sIBJ9yAcAbtCmkwbR/TT7rJrXnlaudKVaP5zXX2reAzwNn8U7HCsggpqL3Tuqs7TwrA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.16";
        hash = "sha512-A0SPb3IgPfZFJ6NxfpUy5pIbBAoJf3A0HRweOnGf8DC2iFrNmnq91EvUEXh5AOfICy1WodLKq0d/J4X/3AN5pA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.16";
        hash = "sha512-ZEypTI3fTfMFs6RNeKd7sDcEe6LI/vFQOFCynh8m2EqKRs/zPdA3z933wPvQC4ITBIAtvuXrpzC6jKQ4pZbDOA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.16";
        hash = "sha512-3ow2+iasnsRtBppcLG056Iypvxo5F/1dCBPdSuvr+yHJJtgiNcZ7eF+pVJt8PGrExR6fZEpQkCebu2fOCJUAHw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-MebNoPFtZfUrZYOzQxLzBORGWymR4X++6qu/HG9aqyKD506zdADS+0ywvP11qYwxhx1FkEZGT0oCQco77/GFjw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.16";
        hash = "sha512-8R5L6sMPLJM51sHk3Q8BgPAhY9lXA8PVWvW1CR5XWlIbwVvwoQ3H11Arwm2Guizj9K17psMLaD2DWdre5qO6ww==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.16";
        hash = "sha512-BT7jvlg8g1FWnvWP2SteaRLfMiYH/QpDqFZPqBlvHjpeLISoy/2FWObwdRNAYMmtWxsZteqsx5fsIeh/FVkvMw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.16";
        hash = "sha512-UXYB5NPkbRW02xoiHzA0Zxls25W7S/PDFcMdt57yJ1Xd93NA6x/x1jjpJl2+HXJs934oyaiRT4DRpBg0IUV60A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-3aC762Jibkme5+Xk0iVU9UUlFxc4hGjFxr11yuOMUf+JDeAmlq3nmmF2XOvCPVaN7y9ZRfum1zE3OeelHLJBXw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.16";
        hash = "sha512-+Y55F+0pJvJlWnWzw9z3UTE1Ld6atGebLqKM3NwjhrWJkNOYL8fGg8eL0xHx0eg17Xt9DCCuoEo1ORp3/8Kq7w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.16";
        hash = "sha512-YltV3OJFVALzaS7RzoPPnWjYBv8h0VlXfG7psLXuYJN3h/zpgio82d21VCIih/prkjciIWYQyOg9Ms4DHWxH9w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.16";
        hash = "sha512-VOsBzWK4ZePdgZnMhTlJnDFuAv3tHk5t/SEUkyQyO5fV3D5s5tbYF6LfYSBkX0kHpeBu/C8rfcNrfysRgIZUow==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.16";
        hash = "sha512-QGKtIoxAgUpNvSXz0SOmfZRsUDgeXmJEcM8GwxFEFGWOz+ngb+7yGxGUTl7YJf3oJBjTE4dWlECIzwDer3NxMw==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.16";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.16";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-linux-arm.tar.gz";
        hash = "sha512-+gspAwwni0nfmN5fAPMYfR8d5Qz7CnyRAWC/iU7qhJ3UZP4nsCBM5Mt4U54zBWOAIchC+K/2hovOj2nTWS96Gw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-linux-arm64.tar.gz";
        hash = "sha512-hfJBz4m49vsfl7RS4Q0Z4vAh+eWV7t00Ld/tijpTWWpSg+G2teSefh1nwqA8+lJhWDXjx88AY57UCwgsTkKd/w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-linux-x64.tar.gz";
        hash = "sha512-AMDHOl08pWB9jh2wIECaIBvLQkaeTk9/uZKpnoqO+kFlfowr0pyZzB+XMx0LR7t1JWR52UU2SWIaOsoYogL0jg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-linux-musl-arm.tar.gz";
        hash = "sha512-KoSXRwHxWJnRYgwln0y4nt/MzSl/1T7DMmdgjuvuP6nKofFCYLWYvz4Fd+6gxtMno3ChYtskGWWc4p4olUxE4g==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-linux-musl-arm64.tar.gz";
        hash = "sha512-V7THD485pAAIjZtmuFq/ZxLKC9ESLVVrwmFLUZm6p5I0ElF/Pn02st/HjAaqtZBN2ufSRPTZPAHtEobKEhtsKw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.16/aspnetcore-runtime-9.0.16-linux-musl-x64.tar.gz";
        hash = "sha512-/giB6HP7DeDUuevKKtJgUo1CyCQPiCA793t1+BKzJcPilUqqT0q3iK1SBkWSXmzFNy0Hmui5hQnuJJX3BCpfaw==";
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
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-linux-arm.tar.gz";
        hash = "sha512-It4KwzCKBeBcXLnVFxuXpZEYW5Uoy3k7CWCU4PEiU2TfpNxYmlW2CEXAVY6jhoQg/6VmFoDhh7vAr1XM9varZw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-linux-arm64.tar.gz";
        hash = "sha512-7yrr47d1WXPsWpAHxYD8l0ZCnd8FS996wQexsB68vtqtGZYC8WyeYv306wqgK6S863sa9sVzctCeMhpAxDe3vg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-linux-x64.tar.gz";
        hash = "sha512-M+AI6+tEdk4HQJpkYKdFL/TOWZ0HYWOztjju2f/wdY/TVXtjgoJFlZxDylSsD94NSq6ZAAvVdXeBVXIlK98nqQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-linux-musl-arm.tar.gz";
        hash = "sha512-Riiv/scRdZQ9W1dAHwToGFRFE9ApBJQ+k4mI3L6Ou8u+oL9lXsGgsy7+SfVBylhxFLOi9dk5eR9nSxOU4aZEyQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-linux-musl-arm64.tar.gz";
        hash = "sha512-RJgHSbsslJoMzTFnoUKXvMbFlxg9coXai3wP3zRy3tBbWM8AOYtPnFaAiJXJdMW/tIXtH/BOmrfWWg7Zw0KbbQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.16/dotnet-runtime-9.0.16-linux-musl-x64.tar.gz";
        hash = "sha512-aUpp5dh8jmO0XJbzNs9OhhpWq/irVWFZVuGFdftNEdAUIbu8oPZtHMDY8wId+t5f1fhSnXlDyIM1K5vePZnntA==";
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

  sdk_9_0_3xx = buildNetSdk {
    version = "9.0.314";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.314/dotnet-sdk-9.0.314-linux-arm.tar.gz";
        hash = "sha512-gNQ03GgGaLpkfDNB4RGYImXhDalCQClxSPaPLJ34irualJ+bW2p8TkbgEpHTKan3B6JzhDnCTj6CnT1+//OMbg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.314/dotnet-sdk-9.0.314-linux-arm64.tar.gz";
        hash = "sha512-C5fCnSVtITYfstb/rtGkSsN6RozlzqD6bybQKjiYxMRmxsRJGNkX2Zce8mmJY8VZ77pgM9Tv+MByt1AxCkvBew==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.314/dotnet-sdk-9.0.314-linux-x64.tar.gz";
        hash = "sha512-nMglC547vCm2TlWGaxAH1JoVXko3kFcONzFeQXX7+uouBv849qq9ieNdlD+ZFbM7MtaqM+jUGaj7nXGIzsl6GA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.314/dotnet-sdk-9.0.314-linux-musl-arm.tar.gz";
        hash = "sha512-2ai1k3GmLAMun5ThJ4eC+7D68yB9g0VzjKhtpUmZnGSwTPM7LD66NjoiaJKBRAIjCYXVIrftF2ljtHwaTl/oMQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.314/dotnet-sdk-9.0.314-linux-musl-arm64.tar.gz";
        hash = "sha512-m8neM4NAEPK8rkk8lPrFvtVjYiyoavb0ZDJwl05Jw2XH5i9By4TMQ782kVCA+AyugL6ExET/sghYMPwy5hMqJA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.314/dotnet-sdk-9.0.314-linux-musl-x64.tar.gz";
        hash = "sha512-42VhdNcHJIDpjdJWhOYlWs8NQ2AGTxV7PhfBY+bNfwqHF1Q+TnnaSceE+ww5/zepFDTVv2lElS9qc4kRR0674Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.314/dotnet-sdk-9.0.314-osx-arm64.tar.gz";
        hash = "sha512-2qlBz3K2cRSLICQDf+aqTeLr9wg9DnjF0+F5tEVUsEnjzQRUw5Y52zpmjdPbp+UkBlEjOSn6w/XRNgxgV55/Vg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.314/dotnet-sdk-9.0.314-osx-x64.tar.gz";
        hash = "sha512-KusG9KH+592tV3kQMhD/7SxU67mrDTrT965h3sEEiEj2akWrjX087st3RrLSqDCxBd1AY9P3nOaoZevrs5tUNw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.117";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-linux-arm.tar.gz";
        hash = "sha512-SxZteXCcnh5nBPxyDWvYcdM/eDauPJ1vb99Db41uWm5YR3mnJ70f0576RpPPOsLwEZ8IE3IZbpN7bAeMMHAApA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-linux-arm64.tar.gz";
        hash = "sha512-BVeI2RNXCcolRB+AP+mAHNMyfYx8pCRO6IKKLwwxLCFcrxVb8+LvKgcAS5iB2ogGEKAQ5mByhNVljofDtRVONQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-linux-x64.tar.gz";
        hash = "sha512-f//fJ8eA+ud5M7iH/WQJFm2c/1SKJsK4coWm8NwSb+sekQohTp1yZxfkTU2/bWkzbnkuYIWwjK2EPXs62fTp2A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-linux-musl-arm.tar.gz";
        hash = "sha512-q3WfL7z8NvGVTbS2xQl8fLqmCUDkA/hFlJwXoGuJQTceMwe2IkrgsnOnHaniqgOjgwXUpGzD87K8vm8dhDQKGw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-linux-musl-arm64.tar.gz";
        hash = "sha512-7MdZmFyY2wgMqyw1lMd7kl0CcISShbyMWnWcBYUYU+GzSaBfgMDAnUcKA9CRVrIggJsEp/1ut8WpzOHujqFF6Q==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.117/dotnet-sdk-9.0.117-linux-musl-x64.tar.gz";
        hash = "sha512-wVb2XxR7t44nOG05BcyESAmdbgevAIKrUHfZxvqoPz4fc6WI+72M1MbLrdgEAgu5t7//lrCV9UQy93RassmI3g==";
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

  sdk_9_0 = sdk_9_0_3xx;
}
