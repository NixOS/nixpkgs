{ ecm
, kdeApp
, lib
, qtdeclarative
}:

kdeApp {
  name = "kholidays";
  meta = {
    description = "Holiday calculation library";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [ ecm qtdeclarative ];
}
